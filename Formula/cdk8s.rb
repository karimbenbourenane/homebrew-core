require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.151.tgz"
  sha256 "4bfb252e68550de452c05d551579c92add19a267caa9e74b6d31c269b9da3057"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5490fb059d17e97a9cb2c1ffebd1bff936a668af3a3c3fe01f47105b9721259d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
