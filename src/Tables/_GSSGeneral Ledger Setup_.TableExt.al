tableextension 60105 "GSSGeneral Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(60100; "GSSDefault Global Dim. 1 Value"; Code[20])
        {
            Caption = 'Default Global Dim. 1 Value';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code"=FIELD("Global Dimension 1 Code"));
        }
        field(60101; JobExpiryNotificationEmail; Text[250])
        {
            Caption = 'Job Expiry Email';
            DataClassification = CustomerContent;
        }
    }
}
