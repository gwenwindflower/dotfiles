use clap::Parser;

/// @@DESCRIPTION@@
#[derive(Parser)]
#[command(version, about)]
struct Cli {}

fn main() {
    let _cli = Cli::parse();
    println!("@@TOOL_BINARY@@ is alive");
}
