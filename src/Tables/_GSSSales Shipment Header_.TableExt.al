tableextension 60124 "GSSSales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Line"."Job No." where("Document No."=field("No."), "Job No."=filter(<>'')));
        }
    }
}
