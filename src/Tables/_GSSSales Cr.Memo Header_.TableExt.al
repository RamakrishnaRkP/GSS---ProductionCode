tableextension 60126 "GSSSales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Line"."Job No." where("Document No."=field("No."), "Job No."=filter(<>'')));
        }
    }
}
