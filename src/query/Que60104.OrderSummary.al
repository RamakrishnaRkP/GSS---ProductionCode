table 60104 "Project Posting Summary"
{
    Caption = 'Project Posting Summary';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(2; "Project Posting Group"; Code[20]) { Caption = 'Project Posting Group'; }
        field(3; "Job No."; Code[20]) { Caption = 'Job No.'; }
        field(4; "Sales Value"; Decimal) { Caption = 'Sales Value'; }
        field(5; "Cost Value"; Decimal) { Caption = 'Cost Value'; }
        field(6; "Gross Margin"; Decimal) { Caption = 'Gross Margin'; }
        field(7; "Gross Margin Percent"; Decimal) { Caption = 'Gross Margin %'; }
        field(8; "Total Cost Value"; Decimal) { Caption = 'Total Cost Value'; }

        field(9; "Document Type"; Text[30])
        {
            Caption = 'Document Type';
        }
        field(10; "Line Type"; Text[50])
        {
            Caption = 'Line Type';
        }
        field(11; "Document Cost"; Decimal)
        {
            Caption = 'Document Cost';
        }
        field(12; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(13; "Source Type"; Text[20]) { Caption = 'Source Type'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(JobNo; "Job No.") { }
    }
}

query 60104 "Project Posting Summary Calc"
{
    QueryType = Normal;

    elements
    {
        // Project Posting Group is stored per Job Task (e.g. PROJ-EXP, PROJ-RES, AMC),
        // so start from Job Task. Job Task No. is not a column, so tasks that share
        // the same posting group are summed together into one row per job.
        dataitem(JobTask; "Job Task")
        {
            column(JobNo; "Job No.") { }
            column(ProjectPostingGroup; "Job Posting Group") { }

            dataitem(JobPlanningLine; "Job Planning Line")
            {
                DataItemLink = "Job No." = JobTask."Job No.", "Job Task No." = JobTask."Job Task No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Line Type" = filter(Budget | "Both Budget and Billable");


                // Optional: restrict to billable lines only
                // DataItemTableFilter = "Line Type" = filter(Billable | "Both Budget and Billable");

                column(SalesValue; "Line Amount") { Method = Sum; }
                column(CostValue; "Total Cost") { Method = Sum; }
            }
        }
    }
}

page 60184 "Ordersummary"
{
    PageType = API;
    APIPublisher = 'GSS';
    APIGroup = 'Ordersummary';
    APIVersion = 'v1.0';
    EntityName = 'ordersummary';
    EntitySetName = 'ordersummary';
    SourceTable = "Project Posting Summary";
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
                field(projectPostingGroup; Rec."Project Posting Group") { Caption = 'Project Posting Group'; }
                field(jobNo; Rec."Job No.") { Caption = 'Job No.'; }
                field(salesValue; Rec."Sales Value") { Caption = 'Sales Value'; }
                field(costValue; Rec."Cost Value") { Caption = 'Cost Value'; }
                field(totalCostValue; Rec."Total Cost Value") { Caption = 'Total Cost Value'; }

                field(grossMargin; Rec."Gross Margin") { Caption = 'Gross Margin'; }
                field(grossMarginPercent; Rec."Gross Margin Percent") { Caption = 'Gross Margin %'; }

                // field(documentType; Rec."Document Type")
                // {
                //     Caption = 'Document Type';
                // }

                // field(lineType; Rec."Line Type")
                // {
                //     Caption = 'Line Type';
                // }

                // field(documentCost; Rec."Document Cost")
                // {
                //     Caption = 'Document Cost';
                // }

            }
        }
    }

    trigger OnOpenPage()
    var
        SummaryQuery: Query "Project Posting Summary Calc";
        EntryNo: Integer;
    begin
        // Temporary table starts empty, so no Reset/DeleteAll is needed.
        SummaryQuery.Open();
        while SummaryQuery.Read() do begin
            EntryNo += 1;
            Rec.Init();
            Rec."Entry No." := EntryNo;
            Rec."Job No." := SummaryQuery.JobNo;
            Rec."Project Posting Group" := SummaryQuery.ProjectPostingGroup;
            Rec."Sales Value" := SummaryQuery.SalesValue;
            Rec."Cost Value" := SummaryQuery.CostValue;
            // Rec."Total Cost Value" += SummaryQuery.CostValue;
            Rec."Total Cost Value" := GetTotalCostForJob(SummaryQuery.JobNo);
            Rec."Gross Margin" := SummaryQuery.SalesValue - SummaryQuery.CostValue;
            if SummaryQuery.SalesValue <> 0 then
                Rec."Gross Margin Percent" := Round((Rec."Gross Margin" / SummaryQuery.SalesValue) * 100, 0.01)
            else
                Rec."Gross Margin Percent" := 0;

            Rec.Insert();
        end;
        SummaryQuery.Close();

        // Load grouped document costs without changing project rows.
        // LoadPurchaseOrderCostSummary(EntryNo);
        // LoadPurchaseReturnOrderCostSummary(EntryNo);
        // LoadSalesReturnOrderCostSummary(EntryNo);
    end;



    local procedure LoadPurchaseOrderCostSummary(
        var EntryNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if PurchaseLine.FindSet() then
            repeat
                AddOrUpdateDocumentCost('Purchase Order', Format(PurchaseLine.Type), PurchaseLine."Unit Cost (LCY)" * PurchaseLine.Quantity, EntryNo);
            until PurchaseLine.Next() = 0;
    end;

    local procedure LoadPurchaseReturnOrderCostSummary(
        var EntryNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::"Return Order");
        if PurchaseLine.FindSet() then
            repeat
                AddOrUpdateDocumentCost('Purchase Return Order', Format(PurchaseLine.Type), PurchaseLine."Unit Cost (LCY)" * PurchaseLine.Quantity, EntryNo);
            until PurchaseLine.Next() = 0;
    end;

    local procedure LoadSalesReturnOrderCostSummary(
        var EntryNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Return Order");
        if SalesLine.FindSet() then
            repeat
                AddOrUpdateDocumentCost('Sales Return Order', Format(SalesLine.Type), SalesLine."Unit Cost (LCY)" * SalesLine.Quantity, EntryNo);
            until SalesLine.Next() = 0;
    end;

    local procedure AddOrUpdateDocumentCost(
        DocumentType: Text[30];
        LineType: Text[50];
        LineCost: Decimal;
        var EntryNo: Integer)
    begin
        // Search for an existing group in the same temporary table.
        Rec.Reset();
        Rec.SetRange("Document Type", DocumentType);
        Rec.SetRange("Line Type", LineType);
        if Rec.FindFirst() then begin
            Rec."Document Cost" += LineCost;
            Rec.Modify();
        end else begin
            EntryNo += 1;

            Rec.Reset();
            Rec.Init();

            Rec."Entry No." := EntryNo;
            Rec."Document Type" := DocumentType;
            Rec."Line Type" := LineType;
            Rec."Document Cost" := LineCost;

            Rec.Insert();
        end;

        //  Rec.Reset();
    end;

    local procedure GetTotalCostForJob(JobNo: Code[20]): Decimal
    var
        JobPlanningLine: Record "Job Planning Line";
        TotalCost: Decimal;
    begin
        TotalCost := 0;

        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", JobNo);
        JobPlanningLine.SetFilter("Line Type", '%1|%2',
            JobPlanningLine."Line Type"::Budget,
            JobPlanningLine."Line Type"::"Both Budget and Billable");
        if JobPlanningLine.FindSet() then
            repeat
                TotalCost += JobPlanningLine."Total Cost";
            until JobPlanningLine.Next() = 0;

        exit(TotalCost);
    end;
}
