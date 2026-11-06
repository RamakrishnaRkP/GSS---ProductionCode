tableextension 60111 "GSSJob Planning Line" extends "Job Planning Line"
{
    fields
    {
        field(60100; "GSSStatus";Enum "GSSJob Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Job.GSSStatus where("No."=field("Job No.")));
            Caption = 'Document Status';
            Editable = false;
        }
        field(60101; "GSSSupply From"; Code[20])
        {
            Caption = 'Supply From';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                TestStatusOpen();
                TestPostedTable();
            end;
        }
        field(60105; "GSSRenewal Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Renewal Date';
        }
        field(60110; "GSSGlobal Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Job Task"."Global Dimension 1 Code" where("Job No."=field("Job No."), "Job Task No."=field("Job Task No.")));
        }
        field(60111; "GSSGlobal Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Job Task"."Global Dimension 2 Code" where("Job No."=field("Job No."), "Job Task No."=field("Job Task No.")));
        }
        field(60115; "GSSItem Type";Enum "Item Type")
        {
            Editable = false;
            Caption = 'Item Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Type where("No."=field("No.")));
        }
        field(60116; "PO Reference"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."No." where("GSSJob No."=field("Job No."), "Buy-from Vendor No."=field("GSSSupply From")));
        }
        field(60117; "GSSSupply From Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No."=field("GSSSupply From")));
        }
        field(60118; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Job Ledger Entry"."Posting Date" where("Job No."=field("Job No."), "Entry Type"=const(Usage), "No."=field("No.")));
        }
    }
    trigger OnBeforeInsert()
    begin
    //TestStatusOpen();
    end;
    trigger OnBeforeDelete()
    begin
        TestStatusOpen();
        CheckReservedQuantityBeforeDelete();
    end;
    procedure TestPostedTable()
    var
        myInt: Integer;
    begin
        TestField("Qty. Invoiced", 0);
        TestField("Qty. Posted", 0);
    end;
    procedure ValidateLobValue()
    var
        myInt: Integer;
        Item: Record Item;
        Resource: Record Resource;
        JobTaskLine: Record "Job Task";
    begin
        if not JobTaskLine.Get("Job No.", "Job Task No.")then exit;
        if JobTaskLine."Global Dimension 1 Code" = '' then exit;
        if(Type <> Type::Item) AND (Type <> Type::Resource)then exit;
        if Type = Type::Item then begin
            if Item.Get("No.")then Item.TestField("Global Dimension 1 Code", JobTaskLine."Global Dimension 1 Code");
        end;
        if Type = Type::Resource then begin
            if Resource.Get("No.")then Resource.TestField("Global Dimension 1 Code", JobTaskLine."Global Dimension 1 Code");
        end;
    end;
    procedure CheckReservedQuantityBeforeDelete()
    begin
        CalcFields("Reserved Quantity");
        Rec.TestField("Reserved Quantity", 0);
    end;
}
