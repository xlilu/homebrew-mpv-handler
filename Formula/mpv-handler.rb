class MpvHandler < Formula
  desc "Open web videos in mpv using browser protocol links"
  homepage "https://github.com/xlilu/mpv-handler"
  url "https://github.com/xlilu/mpv-handler/archive/92bbe6d4441e94aac51c37d98367929a5af7ff60.tar.gz"
  version "0.4.2"
  sha256 "b841bf13476bfae73ff1ad7b91c63838a1d5e58bcf1b0d1f122c869648e5c43b"
  license "MIT"
  revision 1

  depends_on "rust" => :build
  depends_on :macos
  depends_on "mpv"
  depends_on "yt-dlp"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    bin.install "share/macos/create-mpv-handler-app.sh" => "create-mpv-handler-app"
  end

  def caveats
    <<~EOS
      To create the macOS app for opening mpv-handler:// links, run:
        create-mpv-handler-app

      The handler reads config.toml and cookies/ under ~/.config/mpv-handler/
      or under $XDG_CONFIG_HOME/mpv-handler/ when the app receives an absolute
      XDG_CONFIG_HOME. If you used ~/Library/Application Support/mpv-handler/,
      copy any missing settings and cookie files to the active configuration directory.
    EOS
  end

  test do
    player = testpath/"capture-player"
    player.write <<~'SH'
      #!/bin/sh
      printf '%s\n' "$@" > mpv-arguments
    SH
    chmod 0755, player
    ENV["PATH"] = testpath.to_s
    ENV["HOME"] = testpath.to_s
    custom = testpath/"custom config"
    locations = { "relative-config" => testpath/".config", custom.to_s => custom }
    locations.each do |xdg_config_home, base|
      ENV["XDG_CONFIG_HOME"] = xdg_config_home
      config = base/"mpv-handler"
      cookie = config/"cookies/example.txt"
      cookie.dirname.mkpath
      cookie.write "# Netscape HTTP Cookie File\n"
      (config/"config.toml").write %(mpv = "#{player}"\n)

      url = "mpv-handler://play/aHR0cHM6Ly9leGFtcGxlLm9yZy92aWRlbw/?startat=42&cookies=example.txt"
      system bin/"mpv-handler", url
      expected = ["--ytdl-raw-options-append=cookies=#{cookie}", "--start=42", "--", "https://example.org/video"]
      assert_equal expected, (testpath/"mpv-arguments").read.lines(chomp: true)
    end
  end
end
