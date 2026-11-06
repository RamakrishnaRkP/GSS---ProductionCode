tableextension 60128 "GSSSales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line Archive"."Job No." where("Document Type"=field("Document Type"), "Document No."=field("No."), "Version No."=field("Version No."), "Job No."=filter(<>'')));
        }
    }
}
