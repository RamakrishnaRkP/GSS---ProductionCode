tableextension 60113 "GSSCompany Information" extends "Company Information"
{
    fields
    {
        field(60100; "GSSCompany Shortcode"; Text[30])
        {
            Caption = 'Company Shortcode';
            DataClassification = CustomerContent;
        }
        field(60101; "Account No. (AED)"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60102; "Account No. (USD)"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60103; "IBAN (AED)"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60104; "IBAN (USD)"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60105; "Bank Address"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
}
