{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit MirrorKOLPackage;

interface

uses
  KOL, KOLadd, KOLDirDlgEx, MIRROR, mckCtrls, mckObjs, mckLazarusIdeTemplates, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('MIRROR', @MIRROR.Register);
  RegisterUnit('mckCtrls', @mckCtrls.Register);
  RegisterUnit('mckObjs', @mckObjs.Register);
  RegisterUnit('mckLazarusIdeTemplates', @mckLazarusIdeTemplates.Register);
end;

initialization
  RegisterPackage('MirrorKOLPackage', @Register);
end.
