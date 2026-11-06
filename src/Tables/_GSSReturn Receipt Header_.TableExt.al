tableextension 60127 "GSSReturn Receipt Header" extends "Return Receipt Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Return Receipt Line"."Job No." where("Document No."=field("No."), "Job No."=filter(<>'')));
        }
    }
}
