class MpvHandler < Formula
  desc "Open web videos in mpv using browser protocol links"
  homepage "https://github.com/xlilu/mpv-handler"
  url "https://github.com/xlilu/mpv-handler/archive/99259c067ce7b23eb7c70e476e3165cd39a2a66b.tar.gz"
  version "0.4.2"
  sha256 "449c9499f921199a5446181fc5269dabf4c5bd12b70a268961965f08667676ce"
  license "MIT"

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
    EOS
  end

  test do
    (testpath/"mpv").write <<~'SH'
      #!/bin/sh
      printf '%s\n' "$@" > mpv-arguments
    SH
    chmod 0755, testpath/"mpv"
    ENV.prepend_path "PATH", testpath

    system bin/"mpv-handler", "mpv-handler://play/aHR0cHM6Ly9leGFtcGxlLm9yZy92aWRlbw/?startat=42"
    assert_equal ["--start=42", "--", "https://example.org/video"], (testpath/"mpv-arguments").read.lines(chomp: true)
  end
end
