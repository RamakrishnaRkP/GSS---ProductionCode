tableextension 60110 "GSSJob Task" extends "Job Task"
{
    fields
    {
        field(60100; "GSSStatus"; Enum "GSSJob Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Job.GSSStatus where("No." = field("Job No.")));
            Caption = 'Document Status';
            Editable = false;
        }
        field(60110; "GSSRenewal Date"; Date)
        {
            Caption = 'Renewal Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Job Planning Line"."GSSRenewal Date" where("Job No." = field("Job No."), "Job Task No." = field("Job Task No.")));
        }
        modify("Global Dimension 1 Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
                ValidateGlobalDimension1();
            end;
        }
        modify("Global Dimension 2 Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Job Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Job Task No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("Job Task Type")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }
        modify("WIP Method")
        {
            trigger OnBeforeValidate()
            begin
                //TestStatusOpen();
            end;
        }
        modify("WIP-Total")
        {
            trigger OnBeforeValidate()
            begin
                //TestStatusOpen();
            end;
        }
        modify(Description)
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpen();
            end;
        }

        ///Rk

        field(60111; "GSSGross Margin"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Margin ';
            Editable = false;
        }
        field(60112; "GSSGross Margin %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Margin %';
            Editable = false;
        }
    }
    trigger OnBeforeInsert()
    begin
        TestStatusOpen();
    end;

    trigger OnBeforeDelete()
    begin
        TestStatusOpen();
    end;

    trigger OnAfterInsert()
    begin
        Rec.Validate("WIP-Total", Rec."WIP-Total"::Total)
    end;

    local procedure TestStatusOpen()
    begin
        CalcFields(GSSStatus);
        TestField(GSSStatus, GSSStatus::Open);
    end;

    local procedure ValidateGlobalDimension1()
    var
        Item: Record Item;
        Resource: Record Resource;
        JobPlanningLine: Record "Job Planning Line";
    begin
        if Rec."Global Dimension 1 Code" = xRec."Global Dimension 1 Code" then
            exit;
        JobPlanningLine.SetCurrentKey("Job No.", "Job Task No.", "Line No.");
        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
        JobPlanningLine.SetRange("Job Task No.", Rec."Job Task No.");
        JobPlanningLine.SetFilter(Type, '%1|%2', JobPlanningLine.Type::Item, JobPlanningLine.Type::Resource);
        if not JobPlanningLine.FindFirst() then
            exit;
        if JobPlanningLine.FindFirst() then
            repeat
                Clear(Item);
                Clear(Resource);
                if JobPlanningLine.Type = JobPlanningLine.Type::Item then begin
                    if Item.Get(JobPlanningLine."No.") then
                        Item.TestField("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
                end;
                if JobPlanningLine.Type = JobPlanningLine.Type::Resource then begin
                    if Resource.Get(JobPlanningLine."No.") then
                        Resource.TestField("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
                end;
            until JobPlanningLine.Next() = 0;
    end;
}
