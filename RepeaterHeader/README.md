# How to change font in repeater header
This example shows how to change font in a table header in Nav 2017.
1. Add to the page a field with `Microsoft.Dynamics.Nav.Client.PageReady` addin.
2. Add global variables:
```
CurrForm@1000000002 : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.Form" RUNONCLIENT;
BusinessGridView@1000000001 : DotNet "'Microsoft.Dynamics.Framework.UI.WinForms.Controls, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Framework.UI.WinForms.Controls.BusinessGridView" RUNONCLIENT;
```
3. Add function `ChangeHeaderStyle()`: 
```
LOCAL PROCEDURE ChangeHeaderStyle();
    VAR
      FileMngt : Codeunit 419;
      ArrayOfControls : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array" RUNONCLIENT;
      Application : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.Application" RUNONCLIENT;
      FormCollection : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.FormCollection" RUNONCLIENT;
      Style : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.DataGridViewCellStyle" RUNONCLIENT;
      Column : DotNet "'Microsoft.Dynamics.Framework.UI.WinForms.Controls, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Framework.UI.WinForms.Controls.BusinessGridViewColumn" RUNONCLIENT;
      Color : DotNet "'System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Drawing.Color" RUNONCLIENT;
      Font : DotNet "'System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Drawing.Font" RUNONCLIENT;
      FontStyle : DotNet "'System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Drawing.FontStyle" RUNONCLIENT;
    BEGIN
      IF NOT FileMngt.CanRunDotNetOnClient THEN
        EXIT;

      FormCollection := Application.OpenForms;
      CurrForm := FormCollection.Item(FormCollection.Count-1);

      ArrayOfControls := CurrForm.Controls.Find('_DataGrid', TRUE);
      IF ArrayOfControls.Length = 0 THEN EXIT;
      BusinessGridView := ArrayOfControls.GetValue(0);

      FOREACH Column IN BusinessGridView.Columns DO BEGIN
        CASE Column.HeaderText OF
          FIELDCAPTION("No."):         // It will be bold
            BEGIN
              Style := Column.HeaderCell.Style;
              Style.Font := Font.Font(BusinessGridView.ColumnHeadersDefaultCellStyle.Font.FontFamily,
                                      BusinessGridView.ColumnHeadersDefaultCellStyle.Font.Size,
                                      FontStyle.Bold);
            END;
          FIELDCAPTION(Description):  // It will be brown
            BEGIN
              Style := Column.HeaderCell.Style;
              Style.ForeColor := Color.Brown;
            END;
        END;
      END;

    END;
```
4. Run `ChangeHeaderStyle()` on AddInReady of `Microsoft.Dynamics.Nav.Client.PageReady` field

File [Page50001.txt](Page50001.txt) contains example for Item List. It's a copy of standard `Item List` page with changed formatting for `No.` and `Description`.
