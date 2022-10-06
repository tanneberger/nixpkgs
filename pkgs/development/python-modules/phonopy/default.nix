{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pyyaml
, matplotlib
, h5py
, scipy
, spglib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xTbTVRVmJvJuXV/RWLA+EMShPEYdagKiawXjtjEbnXk=";
  };

  propagatedBuildInputs = [
    h5py
    matplotlib
    numpy
    pyyaml
    scipy
    spglib
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # prevent pytest from importing local directory
  preCheck = ''
    rm -r phonopy
  '';

  meta = with lib; {
    description = "A package for phonon calculations at harmonic and quasi-harmonic levels";
    homepage = "https://atztogo.github.io/phonopy/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}
