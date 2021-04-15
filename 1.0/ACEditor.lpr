{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
{$ifdef FPC} {$mode delphi} {$endif}
program ACEditor;

uses
  KOL,
  MainForm, Cmn, ACAttributes;

begin // PROGRAM START HERE -- Please do not remove this comment

{$IFNDEF LAZIDE_MCK} {$I ACEditor_0.inc} {$ELSE}

  Application.Initialize;
  Application.CreateForm(TFrm, Frm);
  Application.Run;

{$ENDIF}

end.
