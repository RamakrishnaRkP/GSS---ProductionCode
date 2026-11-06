report 60171 "Job Ledger Entries - Excel"
{
    Caption = 'Job Ledger Entries - Excel';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(JLE; "Job Ledger Entry")
        {
            trigger OnAfterGetRecord()
            begin
                CreateExcelBody();
                EntriesAvailable:=true;
            end;
            trigger OnPreDataItem()
            begin
                JLE.SetRange("Posting Date", CalcDate('<-CY>', Today), Today);
                CreateExcelHeader();
                EntriesAvailable:=false;
            end;
        }
    }
    trigger OnInitReport()
    begin
        ExcelBuffer.DeleteAll();
    end;
    trigger OnPostReport()
    begin
        if EntriesAvailable then CreatExcelBook()
        else
            Message('No Entries Available');
    end;
    local procedure CreateExcelHeader()
    var
    begin
        ExcelBuffer.AddColumn(JLE.FieldCaption("Posting Date"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Entry Type"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Document No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("External Document No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Job No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Job Task No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption(Type), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption(Description), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Location Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Work Type Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Unit of Measure Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption(Quantity), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Unit Cost"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Unit Cost (LCY)"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Total Cost"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Total Cost (LCY)"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Unit Price"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Line Amount"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Line Discount Amount"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Line Discount %"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Ledger Entry Type"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Ledger Entry No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Entry No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption(Adjusted), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("DateTime Adjusted"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Global Dimension 1 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Global Dimension 2 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Shortcut Dimension 3 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Shortcut Dimension 4 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Shortcut Dimension 5 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Shortcut Dimension 6 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.FieldCaption("Shortcut Dimension 7 Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;
    local procedure CreatExcelBook();
    begin
        ExcelBuffer.CreateNewBook('Job Credit Entries');
        ExcelBuffer.WriteSheet('Job Credit Entries', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Job Credit Entries');
    // ExcelBuffer.OpenExcel();
    end;
    local procedure CreateExcelBody()
    begin
        //   Customer.CalcFields("Balance (LCY)");
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(JLE."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(JLE."Entry Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."External Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Job No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Job Task No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.Type, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Work Type Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Unit of Measure Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Unit Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Unit Cost (LCY)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Total Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Total Cost (LCY)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Unit Price", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Line Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Line Discount Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Line Discount %", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Ledger Entry Type", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Ledger Entry No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Entry No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE.Adjusted, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."DateTime Adjusted", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Global Dimension 1 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Global Dimension 2 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Shortcut Dimension 3 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Shortcut Dimension 4 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Shortcut Dimension 5 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Shortcut Dimension 6 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(JLE."Shortcut Dimension 7 Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;
    var ExpiryDuration: Integer;
    FileName: Label 'Job Ledger Entries %1 -%2';
    ExcelBuffer: Record "Excel Buffer" temporary;
    EntriesAvailable: Boolean;
}
