{ lib
, btrfs-progs
, buildGoModule
, fetchFromGitHub
, lvm2
, pkg-config
}:

buildGoModule rec {
  pname = "kubeclarity";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "openclarity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qXBD3JurBU7RBemj+gr/tBGpfqKhwk5VPBKaTuM4URg=";
  };

  vendorHash = "sha256-L7g48EH3cuhgSZ87JoMVvv5nGDzjUpOufsikINCdhao=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    btrfs-progs
    lvm2
  ];

  sourceRoot = "${src.name}/cli";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/kubeclarity
  '';

  meta = with lib; {
    description = "Kubernetes runtime scanner";
    longDescription = ''
      KubeClarity is a vulnerabilities scanning and CIS Docker benchmark tool that
      allows users to get an accurate and immediate risk assessment of their
      kubernetes clusters. Kubei scans all images that are being used in a
      Kubernetes cluster, including images of application pods and system pods.
    '';
    homepage = "https://github.com/openclarity/kubeclarity";
    changelog = "https://github.com/openclarity/kubeclarity/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
