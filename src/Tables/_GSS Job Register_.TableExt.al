tableextension 60118 "GSS Job Register" extends "Job Register"
{
    fields
    {
        // Add changes to table fields here
        field(50101; "GSS Document No."; Code[20])
        {
            CalcFormula = lookup("Job Ledger Entry"."Document No." WHERE("Entry No."=FIELD("From Entry No.")));
            Caption = 'Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    var myInt: Integer;
}
