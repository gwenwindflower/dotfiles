function uvapp -d "Spin up by base uv FastAPI app template"
    argparse d/desc= l/lib h/help -- $argv
    if set -q _flag_help
        echo "Create a new FastAPI app with uv"
        logirl help_usage "uvapp <app name> [OPTIONS]"
        logirl help_header Options
        logirl help_flag d/desc "App description (default: 'A FastAPI app')"
        logirl help_flag l/lib "Use the library template (default is app template)"
        logirl help_flag h/help "Show this help message"
        return 0
    end
    set -l app_name (string replace -r '\s+' '-' -- $argv)
    if test -z "$app_name"
        logirl error "App name is required"
        return 1
    end
    set -l app_desc "A FastAPI app"
    set -l app_template app
    if set -q _flag_desc
        set app_desc $_flag_desc
    end
    if set -q _flag_lib
        set app_template lib
    end
    uv init $app_name --description=$app_desc --$app_template
    cd $app_name
    uv add fastapi sqlmodel uvicorn
    uv add --dev pytest pytest-asyncio pytest-cov ruff ty httpx httpx-sse
    uv sync
end
