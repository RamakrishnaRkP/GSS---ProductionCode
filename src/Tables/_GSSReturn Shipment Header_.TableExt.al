tableextension 60121 "GSSReturn Shipment Header" extends "Return Shipment Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
            ValidateTableRelation = true;
            Editable = false;
        }
    }
}
