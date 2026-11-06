table 60106 "Sales Cost Summary"
{
    Caption = 'Sales Cost Summary';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(2; "Document Type"; Text[30]) { Caption = 'Document Type'; }
        field(3; "Document No."; Code[20]) { Caption = 'Document No.'; }
        field(4; "Line Type"; Text[50]) { Caption = 'Line Type'; }
        field(5; "Sell-to Customer No."; Code[20]) { Caption = 'Sell-to Customer No.'; }
        field(6; "Document Cost"; Decimal) { Caption = 'Document Cost'; }
        field(7; "Source Type"; Text[20]) { Caption = 'Source Type'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(DocKey; "Document Type", "Document No.", "Line Type") { }
    }
}

query 60186 "Sales Cost Calc"
{
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = filter(Order | "Return Order");

            column(DocumentType; "Document Type") { }
            column(DocumentNo; "Document No.") { }
            column(LineType; Type) { }
            column(SellToCustomerNo; "Sell-to Customer No.") { }
            column(UnitCostLCY; "Unit Price") { }
            column(TotalQuantity; Quantity) { Method = Sum; }
        }
    }
}

page 60185 "Sales Cost Summary API"
{
    PageType = API;
    APIPublisher = 'GSS';
    APIGroup = 'salesCostSummary';
    APIVersion = 'v1.0';
    EntityName = 'salesCostSummary';
    EntitySetName = 'salesCostSummary';
    SourceTable = "Sales Cost Summary";
    SourceTableTemporary = true;
    ODataKeyFields = "Entry No.";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; }
                field(sourceType; Rec."Source Type") { Caption = 'Source Type'; }
                field(documentType; Rec."Document Type") { Caption = 'Document Type'; }
                field(documentNo; Rec."Document No.") { Caption = 'Document No.'; }
                field(lineType; Rec."Line Type") { Caption = 'Line Type'; }
                field(sellToCustomerNo; Rec."Sell-to Customer No.") { Caption = 'Sell-to Customer No.'; }
                field(documentCost; Rec."Document Cost") { Caption = 'Document Cost'; }
            }
        }
    }

    trigger OnOpenPage()
    var
        CostQuery: Query "Sales Cost Calc";
        EntryNo: Integer;
        DocNoFilter: Text;
        SavedView: Text;
    begin
        // Capture what Power Automate sent BEFORE any Reset()
        SavedView := Rec.GetView();
        DocNoFilter := Rec.GetFilter("Document No.");

        // Push the filter into the query so only the needed lines are read
        if DocNoFilter <> '' then
            CostQuery.SetFilter(DocumentNo, DocNoFilter);

        CostQuery.Open();
        while CostQuery.Read() do
            if Format(CostQuery.LineType) <> '' then
                AddOrUpdateCost(
                    CopyStr(Format(CostQuery.DocumentType), 1, 30),
                    CostQuery.DocumentNo,
                    CopyStr(Format(CostQuery.LineType), 1, 50),
                    CostQuery.SellToCustomerNo,
                    CostQuery.UnitCostLCY * CostQuery.TotalQuantity,
                    EntryNo);
        CostQuery.Close();

        // Restore the caller's filter instead of clearing it
        Rec.Reset();
        Rec.SetView(SavedView);
        if Rec.FindFirst() then;
    end;

    local procedure AddOrUpdateCost(
        DocumentType: Text[30];
        DocumentNo: Code[20];
        LineType: Text[50];
        CustomerNo: Code[20];
        LineCost: Decimal;
        var EntryNo: Integer)
    begin
        // The query returns one row per unit cost, so rows of the same
        // document and line type are added together here.
        Rec.Reset();
        Rec.SetRange("Document Type", DocumentType);
        Rec.SetRange("Document No.", DocumentNo);
        Rec.SetRange("Line Type", LineType);
        if Rec.FindFirst() then begin
            Rec."Document Cost" += LineCost;
            Rec.Modify();
        end else begin
            EntryNo += 1;
            Rec.Reset();
            Rec.Init();
            Rec."Entry No." := EntryNo;
            Rec."Source Type" := 'Sales';
            Rec."Document Type" := DocumentType;
            Rec."Document No." := DocumentNo;
            Rec."Line Type" := LineType;
            Rec."Sell-to Customer No." := CustomerNo;
            Rec."Document Cost" := LineCost;
            Rec.Insert();
        end;
    end;
}
