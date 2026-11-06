codeunit 60116 Events
{
    Permissions = tabledata "Cust. Ledger Entry" = RM;
    trigger OnRun()
    begin
    end;

    procedure InsertjobtoCustomerled(Rec: Record "Cust. Ledger Entry")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then
            exit;
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", REc."Document No.");
        if SalesInvoiceLine.FindFirst() then
            Rec."Job No." := SalesInvoiceLine."Job No.";
        Rec.Modify()
    end;

    var
        myInt: Integer;
}