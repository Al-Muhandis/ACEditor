{ KOL MCK } // Do not remove this line!
const miFile = 0;
const miFileSave = 1;
const miFileSaveAs = 2;
const miFileInsertFrom = 3;
const miFileCancel = 5;
const miEdit = 6;
const miEditCancel = 7;
const miEditCut = 9;
const miEditCopy = 10;
const miEditPaste = 11;
const miEditDelete = 12;
const miEditSelectAll = 14;
const miFormat = 15;
const miFormatColor = 16;
const miFormatFont = 17;
const miFormatHeight = 18;
const miFormatOblique = 19;
const miFormatAlignment = 20;
const miFormatStackText = 21;
const miFormatOverline = 22;
const miFormatUnderline = 23;
const miFormatWidthFactor = 24;
const miFormatCharSpace = 25;
const miFormatFree = 27;
const miSymbols = 28;
const miSymbolsNonBreakSpace = 29;
const miSymbolsOpenBrace = 30;
const miSymbolsBackSlash = 31;
const miSymbolsCloseBrace = 32;
const miSymbolsParagEnd = 33;
const miSymbolsDegrees = 35;
const miSymbolsTolerance = 36;
const miSymbolsDiameter = 37;
const miSymbolsUnicode = 39;
const miTools = 40;
const miToolsOpions = 41;
const miHelp = 42;
const N1 = 43;


procedure NewFrm( var Result: PFrm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFrm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, '������ �������������� ������' ).SetPosition( 447, 252 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
{$IFDEF UNICODE_CTRLS}{$IFNDEF wince}
     Result.Form.SetUnicode(TRUE);
{$ENDIF wince}{$ENDIF UNICODE_CTRLS}
   {$IFDEF USE_NAMES}
    Result.Form.SetName( Applet, 'Frm' );
   {$ENDIF}
    Result.Form.SetClientSize( 409, 300 );
    Result.Form.Font.FontPitch := fpVariable;
      Result.Form.OnClose := Result.KOLFrmClose;

    Result.MnMn := NewMenu( Result.Form, 0, [ '����', '(', ' '
      , ' ', ' ', '-' + '', ' ', ')', '������', '(', ' '
      , '-' + '', ' ', ' ', ' ', ' ', '-' + '', ' ', ')'
      , '������', '(', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
      , ' ', ' ', '-' + '', ' ', ')', '�������', '(', ' ', ' '
      , ' ', ' ', ' ', '-' + '', ' ', ' ', ' ', '-' + '', ' '
      , ')', '�����������', '(', ' ', ')', '������', '(', ' '
      , ')', '' ], nil );
   {$IFDEF USE_NAMES}
    Result.MnMn.SetName( Result.Form, 'MnMn' ); 
   {$ENDIF}

    Result.OpnDlgText := NewOpenSaveDialog( '������� ����� �� �����...', '', [  ] );
      Result.OpnDlgText.Filter := '������� ����� (*.txt)|*.txt|��� ����� (*.*)|*.*';
      Result.OpnDlgText.DefExtension := 'txt';
   {$IFDEF USE_NAMES}
    Result.OpnDlgText.SetName( Result.Form, 'OpnDlgText' ); 
   {$ENDIF}
  Result.Form.Add2AutoFree( Result.OpnDlgText );

    Result.SvDlgTextSaveAs := NewOpenSaveDialog( '��������� ����� ���...', '', [ OSHideReadonly, OSOverwritePrompt, OSPathMustExist ] );
      Result.SvDlgTextSaveAs.Filter := '������� ����� (*.txt)|*.txt|��� ����� (*.*)|*.*';
      Result.SvDlgTextSaveAs.OpenDialog := FALSE;
      Result.SvDlgTextSaveAs.DefExtension := 'txt';
   {$IFDEF USE_NAMES}
    Result.SvDlgTextSaveAs.SetName( Result.Form, 'SvDlgTextSaveAs' ); 
   {$ENDIF}
  Result.Form.Add2AutoFree( Result.SvDlgTextSaveAs );

    Result.ActnLst := NewActionList( Result.Form );
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnLst' ); 
   {$ENDIF}
  Result.Form.Add2AutoFree( Result.ActnLst );

































   {$IFDEF USE_NAMES}
    Result.PppMn.SetName( Result.Form, 'PppMn' ); 
   {$ENDIF}
    // Result.Mm.TabOrder = 0
    Result.Mm := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll ] ).SetAlign ( caClient );
   {$IFDEF USE_NAMES}
    Result.Mm.SetName( Result.Form, 'Mm' ); 
   {$ENDIF}
    {$IFNDEF UNICODE_CTRLS}Result.Mm.SetUnicode( TRUE );{$ENDIF}
    Result.Mm.SetAutoPopupMenu( Result.PppMn );
    // Result.PnlBtns.TabOrder = 1
    Result.PnlBtns := NewPanel( Result.Form, esNone ).SetAlign ( caBottom ).SetSize( 0, 34 );
   {$IFDEF USE_NAMES}
    Result.PnlBtns.SetName( Result.Form, 'PnlBtns' ); 
   {$ENDIF}
   {$IFDEF UNICODE_CTRLS}{$IFNDEF wince}
   Result.PnlBtns.SetUnicode(TRUE);
   {$ENDIF wince}{$ENDIF UNICODE_CTRLS}
    Result.PnlBtns.Border := 0;
    // Result.BtnOk.TabOrder = 0
      Result.BtnOk := NewButton( Result.PnlBtns, '' ).SetSize( 241, 34 );
   {$IFDEF USE_NAMES}
      Result.BtnOk.SetName( Result.Form, 'BtnOk' ); 
   {$ENDIF}
   {$IFDEF UNICODE_CTRLS}{$IFNDEF wince}
   Result.BtnOk.SetUnicode(TRUE);
   {$ENDIF wince}{$ENDIF UNICODE_CTRLS}
    // Result.BtnCancel.TabOrder = 1
      Result.BtnCancel := NewButton( Result.PnlBtns, '' ).SetPosition( 241, 0 ).SetSize( 164, 34 );
   {$IFDEF USE_NAMES}
      Result.BtnCancel.SetName( Result.Form, 'BtnCancel' ); 
   {$ENDIF}
   {$IFDEF UNICODE_CTRLS}{$IFNDEF wince}
   Result.BtnCancel.SetUnicode(TRUE);
   {$ENDIF wince}{$ENDIF UNICODE_CTRLS}
      Result.BtnOk.OnClick := Result.BtnOkClick;
    Result.BtnOk.DefaultBtn := TRUE;
    Result.BtnOk.Anchor(TRUE, TRUE, TRUE, TRUE);
      Result.OpnDlgText.WndOwner := Result.Form.GetWindowHandle;
      Result.SvDlgTextSaveAs.WndOwner := Result.Form.GetWindowHandle;

    Result.ActnFileOpen := Result.ActnLst.Add( '�������� ��...', '', Result.ActnFileOpenExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFileOpen' ); 
   {$ENDIF}
//<----
    Result.ActnFileOpen.LinkMenuItem( Result.MnMn, 3 );
    Result.ActnFileOpen.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $4F);

    Result.ActnFileSaveAs := Result.ActnLst.Add( '��������� ���...', '', Result.ActnFileSaveAsExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFileSaveAs' ); 
   {$ENDIF}
//<----
    Result.ActnFileSaveAs.LinkMenuItem( Result.MnMn, 2 );
    Result.ActnFileSaveAs.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $53);

    Result.ActnFileCancel := Result.ActnLst.Add( '��� ���������', '', Result.ActnFileCancelExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFileCancel' ); 
   {$ENDIF}
//<----
    Result.ActnFileCancel.LinkControl( Result.BtnCancel );
    Result.ActnFileCancel.LinkMenuItem( Result.MnMn, 5 );
    Result.ActnFileCancel.Accelerator := MakeAccelerator(FVIRTKEY, VK_ESCAPE);

    Result.ActnFileSave := Result.ActnLst.Add( '���������', '', Result.ActnFileSaveExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFileSave' ); 
   {$ENDIF}
//<----
    Result.ActnFileSave.LinkControl( Result.BtnOk );
    Result.ActnFileSave.LinkMenuItem( Result.MnMn, 1 );
    Result.ActnFileSave.Accelerator := MakeAccelerator(FVIRTKEY, VK_RETURN);

    Result.ActnEditUndo := Result.ActnLst.Add( '��������', '', Result.ActnEditUndoExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditUndo' ); 
   {$ENDIF}
//<----
    Result.ActnEditUndo.LinkMenuItem( Result.MnMn, 7 );

    Result.ActnEditCut := Result.ActnLst.Add( '��������', '', Result.ActnEditCutExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditCut' ); 
   {$ENDIF}
//<----
    Result.ActnEditCut.LinkMenuItem( Result.MnMn, 9 );
    Result.ActnEditCut.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $58);

    Result.ActnEditCopy := Result.ActnLst.Add( '����������', '', Result.ActnEditCopyExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditCopy' ); 
   {$ENDIF}
//<----
    Result.ActnEditCopy.LinkMenuItem( Result.MnMn, 10 );
    Result.ActnEditCopy.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $43);

    Result.ActnEditPaste := Result.ActnLst.Add( '��������', '', Result.ActnEditPasteExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditPaste' ); 
   {$ENDIF}
//<----
    Result.ActnEditPaste.LinkMenuItem( Result.MnMn, 11 );
    Result.ActnEditPaste.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $56);

    Result.ActnEditDelete := Result.ActnLst.Add( '�������', '', Result.ActnEditDeleteExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditDelete' ); 
   {$ENDIF}
//<----
    Result.ActnEditDelete.LinkMenuItem( Result.MnMn, 12 );

    Result.ActnEditSelectAll := Result.ActnLst.Add( '�������� ���', '', Result.ActnEditSelectAllExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditSelectAll' ); 
   {$ENDIF}
//<----
    Result.ActnEditSelectAll.LinkMenuItem( Result.MnMn, 14 );
    Result.ActnEditSelectAll.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $41);

    Result.ActnEditSelectStrings := Result.ActnLst.Add( '�������� ������', '', nil );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnEditSelectStrings' ); 
   {$ENDIF}
//<----

    Result.ActnFormatFont := Result.ActnLst.Add( '�����...', '', Result.ActnFormatFontExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatFont' ); 
   {$ENDIF}
//<----
    Result.ActnFormatFont.LinkMenuItem( Result.MnMn, 17 );
    Result.ActnFormatFont.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $46);

    Result.ActnFormatStack := Result.ActnLst.Add( '����������� �����...', '', Result.ActnFormatStackExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatStack' ); 
   {$ENDIF}
//<----
    Result.ActnFormatStack.LinkMenuItem( Result.MnMn, 21 );

    Result.ActnFormatWidth := Result.ActnLst.Add( '������ �������...', '', Result.ActnFormatWidthExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatWidth' ); 
   {$ENDIF}
//<----
    Result.ActnFormatWidth.LinkMenuItem( Result.MnMn, 24 );

    Result.ActnFormatFree := Result.ActnLst.Add( '�������� ����������������', '', Result.ActnFormatFreeExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatFree' ); 
   {$ENDIF}
//<----
    Result.ActnFormatFree.LinkMenuItem( Result.MnMn, 27 );
    Result.ActnFormatFree.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, VK_DELETE);

    Result.ActnFormatColor := Result.ActnLst.Add( '����...', '', Result.ActnFormatColorExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatColor' ); 
   {$ENDIF}
//<----
    Result.ActnFormatColor.LinkMenuItem( Result.MnMn, 16 );

    Result.ActnFormatOblique := Result.ActnLst.Add( '������...', '', Result.ActnFormatObliqueExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatOblique' ); 
   {$ENDIF}
//<----
    Result.ActnFormatOblique.LinkMenuItem( Result.MnMn, 19 );

    Result.ActnFormatSpace := Result.ActnLst.Add( '������������� ����������...', '', Result.ActnFormatSpaceExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatSpace' ); 
   {$ENDIF}
//<----
    Result.ActnFormatSpace.LinkMenuItem( Result.MnMn, 25 );

    Result.ActnFormatAlignment := Result.ActnLst.Add( '������������...', '', Result.ActnFormatAlignmentExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatAlignment' ); 
   {$ENDIF}
//<----
    Result.ActnFormatAlignment.LinkMenuItem( Result.MnMn, 20 );

    Result.ActnFormatHeight := Result.ActnLst.Add( '������...', '', nil );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatHeight' ); 
   {$ENDIF}
//<----
    Result.ActnFormatHeight.LinkMenuItem( Result.MnMn, 18 );
    Result.ActnFormatHeight.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $48);

    Result.ActnFormatUnderline := Result.ActnLst.Add( '�������������...', '', Result.ActnFormatUnderlineExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatUnderline' ); 
   {$ENDIF}
//<----
    Result.ActnFormatUnderline.LinkMenuItem( Result.MnMn, 23 );

    Result.ActnFormatOverline := Result.ActnLst.Add( '�������������...', '', Result.ActnFormatOverlineExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnFormatOverline' ); 
   {$ENDIF}
//<----
    Result.ActnFormatOverline.LinkMenuItem( Result.MnMn, 22 );

    Result.ActnSymbolsNonBreakSpace := Result.ActnLst.Add( '����������� ������', '', Result.ActnSymbolsNonBreakSpaceExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsNonBreakSpace' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsNonBreakSpace.LinkMenuItem( Result.MnMn, 29 );
    Result.ActnSymbolsNonBreakSpace.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, VK_SPACE);

    Result.ActnSymbolsBackSlash := Result.ActnLst.Add( '�������� �����  \', '', Result.ActnSymbolsBackSlashExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsBackSlash' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsBackSlash.LinkMenuItem( Result.MnMn, 31 );

    Result.ActnSymbolsOpnBrace := Result.ActnLst.Add( '����������� �������� ������  {', '', Result.ActnSymbolsOpnBraceExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsOpnBrace' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsOpnBrace.LinkMenuItem( Result.MnMn, 30 );

    Result.ActnSymbolsCloseBrace := Result.ActnLst.Add( '����������� �������� ������   }', '', Result.ActnSymbolsCloseBraceExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsCloseBrace' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsCloseBrace.LinkMenuItem( Result.MnMn, 32 );

    Result.ActnSymbolsParEnd := Result.ActnLst.Add( '����� ������', '', Result.ActnSymbolsParEndExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsParEnd' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsParEnd.LinkMenuItem( Result.MnMn, 33 );
    Result.ActnSymbolsParEnd.Accelerator := MakeAccelerator(FVIRTKEY or FSHIFT or FCONTROL, VK_RETURN);

    Result.ActnSymbolsDegrees := Result.ActnLst.Add( '������  �', '', Result.ActnSymbolsDegreesExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsDegrees' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsDegrees.LinkMenuItem( Result.MnMn, 35 );
    Result.ActnSymbolsDegrees.Accelerator := MakeAccelerator(FVIRTKEY or FSHIFT or FCONTROL, $44);

    Result.ActnSymbolsTolerance := Result.ActnLst.Add( '�����������  �', '', Result.ActnSymbolsToleranceExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsTolerance' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsTolerance.LinkMenuItem( Result.MnMn, 36 );
    Result.ActnSymbolsTolerance.Accelerator := MakeAccelerator(FVIRTKEY or FSHIFT or FCONTROL, $50);

    Result.ActnSymbolsDiameter := Result.ActnLst.Add( '�������  ', '', Result.ActnSymbolsDiameterExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsDiameter' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsDiameter.LinkMenuItem( Result.MnMn, 37 );
    Result.ActnSymbolsDiameter.Accelerator := MakeAccelerator(FVIRTKEY or FSHIFT or FCONTROL, $43);

    Result.ActnSymbolsUnicode := Result.ActnLst.Add( '������� �������...', '', Result.ActnSymbolsUnicodeExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnSymbolsUnicode' ); 
   {$ENDIF}
//<----
    Result.ActnSymbolsUnicode.LinkMenuItem( Result.MnMn, 39 );
    Result.ActnSymbolsUnicode.Accelerator := MakeAccelerator(FVIRTKEY or FCONTROL, $55);

    Result.ActnToolsOptions := Result.ActnLst.Add( '���������...', '', Result.ActnToolsOptionsExecute );
//---->
   {$IFDEF USE_NAMES}
    Result.ActnLst.SetName( Result.Form, 'ActnToolsOptions' ); 
   {$ENDIF}
//<----
    Result.ActnToolsOptions.LinkMenuItem( Result.MnMn, 41 );

    Result.Mm.Color := clWindow;
    Result.BtnCancel.CancelBtn := TRUE;
    Result.BtnCancel.Anchor(FALSE, TRUE, TRUE, TRUE);
    Result.KOLFrmFormCreate( Result );

end;

