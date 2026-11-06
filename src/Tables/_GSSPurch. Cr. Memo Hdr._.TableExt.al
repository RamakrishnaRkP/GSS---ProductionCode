tableextension 60120 "GSSPurch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
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
