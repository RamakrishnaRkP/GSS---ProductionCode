table 60105 "Purchase Cost Summary"
{
    Caption = 'Purchase Cost Summary';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(2; "Document Type"; Text[30]) { Caption = 'Document Type'; }
        field(3; "Document No."; Code[20]) { Caption = 'Document No.'; }
        field(4; "Line Type"; Text[50]) { Caption = 'Line Type'; }
        field(5; "Buy-from Vendor No."; Code[20]) { Caption = 'Buy-from Vendor No.'; }
        field(6; "Document Cost"; Decimal) { Caption = 'Document Cost'; }
        field(7; "Source Type"; Text[20]) { Caption = 'Source Type'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(DocKey; "Document Type", "Document No.", "Line Type") { }
    }
}

query 60189 "Purchase Cost Calc"
{
    QueryType = Normal;

    elements
    {
        // No table filter, so all purchase documents are returned:
        // Quote, Order, Invoice, Credit Memo, Blanket Order, Return Order
        dataitem(PurchaseLine; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = filter(Order | "Return Order");

            column(DocumentType; "Document Type") { }
            column(DocumentNo; "Document No.") { }
            column(LineType; Type) { }
            column(BuyFromVendorNo; "Buy-from Vendor No.") { }
            column(UnitCostLCY; "Unit Cost (LCY)") { }
            column(TotalQuantity; Quantity) { Method = Sum; }
        }
    }
}

page 60187 "Purchase Cost Summary API"
{
    PageType = API;
    APIPublisher = 'GSS';
    APIGroup = 'purchaseCostSummary';
    APIVersion = 'v1.0';
    EntityName = 'purchaseCostSummary';
    EntitySetName = 'purchaseCostSummary';
    SourceTable = "Purchase Cost Summary";
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
                field(buyFromVendorNo; Rec."Buy-from Vendor No.") { Caption = 'Buy-from Vendor No.'; }
                field(documentCost; Rec."Document Cost") { Caption = 'Document Cost'; }
            }
        }
    }

    trigger OnOpenPage()
    var
        CostQuery: Query "Purchase Cost Calc";
        EntryNo: Integer;
        DocNoFilter: Text;
        DocTypeFilter: Text;
        SavedView: Text;
    begin
        // Capture what Power Automate sent BEFORE any Reset()
        SavedView := Rec.GetView();
        DocNoFilter := Rec.GetFilter("Document No.");
        DocTypeFilter := Rec.GetFilter("Document Type");

        // Push the filter into the query so only the needed lines are read
        if DocNoFilter <> '' then
            CostQuery.SetFilter(DocumentNo, DocNoFilter);
        // Document Type in the query is an enum, so only filter it if the
        // text matches enum values (e.g. Order). Otherwise skip this.
        // if DocTypeFilter <> '' then
        //     CostQuery.SetFilter(DocumentType, DocTypeFilter);

        CostQuery.Open();
        while CostQuery.Read() do
            if Format(CostQuery.LineType) <> '' then
                AddOrUpdateCost(
                    CopyStr(Format(CostQuery.DocumentType), 1, 30),
                    CostQuery.DocumentNo,
                    CopyStr(Format(CostQuery.LineType), 1, 50),
                    CostQuery.BuyFromVendorNo,
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
        VendorNo: Code[20];
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
            Rec."Source Type" := 'Purchase';
            Rec."Document Type" := DocumentType;
            Rec."Document No." := DocumentNo;
            Rec."Line Type" := LineType;
            Rec."Buy-from Vendor No." := VendorNo;
            Rec."Document Cost" := LineCost;
            Rec.Insert();
        end;
    end;
}