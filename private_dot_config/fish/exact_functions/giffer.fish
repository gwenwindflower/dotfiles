function giffer -d "Convert a screen recording to a crisp, doc-friendly GIF via ffmpeg"
    argparse -n giffer \
        h/help \
        'w/width=' \
        'f/fps=' \
        's/speed=' \
        'q/quality=' \
        'p/preset=' \
        'l/loop=' \
        'o/output=' \
        quiet -- $argv
    or return 2

    if set -q _flag_help
        echo "Convert a short screen recording to a crisp GIF tuned for docs sites."
        logirl help_usage "giffer [OPTIONS] <input_video>"
        logirl help_header "Presets (-p/--preset)"
        logirl help_cmd "docs   " "800w · 15fps · 1.5x speed · high quality (default)"
        logirl help_cmd "tiny   " "600w · 12fps · 2x   speed · med  quality — smallest"
        logirl help_cmd "smooth " "900w · 24fps · 1x   speed · high quality — buttery"
        logirl help_cmd "raw    " "source width · 24fps · 1x speed · high — no compromises"
        logirl help_header "Levers (override the preset)"
        logirl help_flag w/width PX "Output width; height auto. 0 = source width"
        logirl help_flag f/fps N "Frame rate (lower = smaller file)"
        logirl help_flag s/speed N "Speed multiplier, e.g. 1.5, 2 (higher = smaller file)"
        logirl help_flag q/quality LEVEL "low | med | high (higher = larger file)"
        logirl help_header Other
        logirl help_flag p/preset NAME "Start from a preset (default: docs)"
        logirl help_flag l/loop N "0 = infinite (default), 1 = play once"
        logirl help_flag o/output FILE "Output path (default: <input>.gif next to input)"
        logirl help_flag quiet "Suppress ffmpeg progress output"
        logirl help_flag h/help "Show this help"
        logirl help_header Examples
        printf "  giffer demo.mov\n"
        printf "  giffer -p tiny demo.mov\n"
        printf "  giffer -p docs -s 2 demo.mov          # docs preset, but 2x speed\n"
        printf "  giffer -w 720 -f 18 -s 1.75 demo.mov  # fully manual\n"
        return 0
    end

    if not type -q ffmpeg
        logirl error "ffmpeg not found in PATH"
        logirl info "Install with: brew install ffmpeg"
        return 127
    end

    if test (count $argv) -ne 1
        logirl error "Expected exactly one input file"
        printf "Try: giffer --help\n"
        return 2
    end

    set -l in $argv[1]
    if not test -f "$in"
        logirl error "Input not found: $in"
        return 1
    end

    # Resolve preset (defaults to docs)
    set -l preset docs
    set -q _flag_preset; and set preset $_flag_preset

    set -l width
    set -l fps
    set -l speed
    set -l quality

    switch $preset
        case docs
            set width 800
            set fps 15
            set speed 1.5
            set quality high
        case tiny
            set width 600
            set fps 12
            set speed 2
            set quality med
        case smooth
            set width 900
            set fps 24
            set speed 1
            set quality high
        case raw
            set width 0
            set fps 24
            set speed 1
            set quality high
        case '*'
            logirl error "Unknown preset: $preset (expected: docs, tiny, smooth, raw)"
            return 2
    end

    # Apply explicit overrides on top of preset
    set -q _flag_width; and set width $_flag_width
    set -q _flag_fps; and set fps $_flag_fps
    set -q _flag_speed; and set speed $_flag_speed
    set -q _flag_quality; and set quality $_flag_quality

    # Quality → palette + dither knobs
    set -l stats_mode
    set -l dither
    set -l max_colors
    switch $quality
        case low
            set stats_mode diff
            set dither "bayer:bayer_scale=5"
            set max_colors 128
        case med
            set stats_mode diff
            set dither sierra2_4a
            set max_colors 256
        case high
            set stats_mode full
            set dither sierra2_4a
            set max_colors 256
        case '*'
            logirl error "Unknown quality: $quality (expected: low, med, high)"
            return 2
    end

    # Loop & verbosity
    set -l loop 0
    set -q _flag_loop; and set loop $_flag_loop

    set -l loglevel warning
    set -q _flag_quiet; and set loglevel error

    # Output path: <input_dir>/<basename>.gif unless overridden
    set -l in_dir (dirname -- "$in")
    set -l in_name (basename -- "$in")
    set -l in_base (string replace -r '\.[^.]+$' '' -- $in_name)

    set -l out
    if set -q _flag_output
        set out $_flag_output
    else
        set out "$in_dir/$in_base.gif"
    end

    # Per-run palette in a fresh tmp dir (BSD mktemp needs trailing X's, no suffix)
    set -l tmp_root $TMPDIR
    test -z "$tmp_root"; and set tmp_root /tmp
    set -l palette_dir (mktemp -d "$tmp_root/giffer.XXXXXXXX")
    set -l palette "$palette_dir/palette.png"

    # Build the shared filter chain so palette stats match the rendered output
    set -l scale_expr
    if test "$width" -eq 0
        set scale_expr "scale=iw:-2:flags=lanczos+accurate_rnd+full_chroma_int"
    else
        set scale_expr "scale=$width:-2:flags=lanczos+accurate_rnd+full_chroma_int"
    end
    set -l common_chain "setpts=PTS/$speed,fps=$fps,$scale_expr"

    # printf-build to avoid fish parsing [v] as a variable index after $common_chain
    set -l gen_filters (printf '%s,palettegen=stats_mode=%s:max_colors=%s' $common_chain $stats_mode $max_colors)
    set -l use_filters (printf '[0:v]%s[v];[v][1:v]paletteuse=dither=%s:diff_mode=rectangle' $common_chain $dither)

    if not set -q _flag_quiet
        logirl special "giffer · preset=$preset width=$width fps=$fps speed="$speed"x quality=$quality"
    end

    # Pass 1: palette
    ffmpeg -hide_banner -loglevel $loglevel -y \
        -i "$in" \
        -vf "$gen_filters" \
        "$palette"
    if test $status -ne 0
        logirl error "Palette generation failed"
        rip "$palette_dir" 2>/dev/null
        return 1
    end

    # Pass 2: render gif
    ffmpeg -hide_banner -loglevel $loglevel -y \
        -i "$in" \
        -i "$palette" \
        -lavfi "$use_filters" \
        -an -loop $loop \
        "$out"
    set -l render_status $status
    rip "$palette_dir" 2>/dev/null
    if test $render_status -ne 0
        logirl error "GIF render failed"
        return 1
    end

    if not set -q _flag_quiet
        set -l size_h (du -h "$out" 2>/dev/null | awk '{print $1}')
        logirl success "Wrote $out ($size_h)"
    end
end
