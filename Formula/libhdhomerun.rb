class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20220303.tgz"
  sha256 "1e54ffefc2d4893911501da31e662b9d063e6c18afe2cb5c6653325277a54a97"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "336e6041951a08ba420b8ef850a7e33d50234ed40a2296f91d9182585caa2b96"
    sha256 cellar: :any, arm64_big_sur:  "bc14665c9ca08d825b980954f49820d880891b71b253720c36fe1533aa1c6558"
    sha256 cellar: :any, monterey:       "95875b8d94b9cdeb9bd83df420f7ab7631f315f14a6498b19f0c48856e64c789"
    sha256 cellar: :any, big_sur:        "dd3696fe6fcd4f64aeaef700271fc13a833bf82d7d49be6043428bbe9ae51ac4"
    sha256 cellar: :any, catalina:       "913fe2b4e1e64dfe288715e6ec64c061fb580df6d2fcb57cd6ae113b00b7d0cf"
    sha256 cellar: :any, mojave:         "a8ad1023d5b5239db535f3757bda0241165c5fc7d13e9b4bdc9fb35c76b7db5d"
  end

  def install
    system "make"
    bin.install "hdhomerun_config"
    lib.install shared_library("libhdhomerun")
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end
