tableextension 60125 "GSSSales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Line"."Job No." where("Document No."=field("No."), "Job No."=filter(<>'')));
        }
        field(60146; "Sales Quote No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type"=const(Quote));
        }
        field(60150; "GSSComments Count"; Integer)
        {
            Caption = 'Comments Count';
            FieldClass = FlowField;
            CalcFormula = count("Sales Comment Line" where("Document Type"=const("Posted Invoice"), "No."=field("No.")));
        }
    }
    trigger OnAfterInsert()
    var
        JobRec: Record Job;
    begin
    end;
}
