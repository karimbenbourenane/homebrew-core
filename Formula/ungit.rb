require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.48.tgz"
  sha256 "691447a39ac4729c2b0ee2705cc21b9d239063354b78583853d1c053347758b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "32cc8801611cb74068f8545f12adf5d9ff660f136ba9c189ce7eb0377ca8f03f" => :catalina
    sha256 "e233e8cb64931db8e7e2619c17caa5ea9312b13c527bf6c615266a56b88114a1" => :mojave
    sha256 "29a874ac4d0ece018d37992264a3b0e58d8782ebcbb1d9593f07341d1a77e52d" => :high_sierra
    sha256 "55a92e5decc65e32fe6db750d4152680a65e013fd47ce727e1ef034650c479d5" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "nokogiri"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    ppid = fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}", "--autoShutdownTimeout=6000"
    end
    sleep 5
    assert_match "ungit", Nokogiri::HTML(shell_output("curl -s 127.0.0.1:#{port}/")).at_css("title").text
  ensure
    Process.kill("TERM", ppid)
    # ensure that there are no spawned child processes left
    child_p = shell_output("ps -o pid,ppid").scan(/^(\d+)\s+#{ppid}\s*$/).map { |p| p[0].to_i }
    child_p.each { |pid| Process.kill("TERM", pid) }
    Process.wait(ppid)
  end
end
