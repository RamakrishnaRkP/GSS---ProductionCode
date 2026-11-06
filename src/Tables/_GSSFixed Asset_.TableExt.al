tableextension 60114 "GSSFixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(60100; "GSSAsset Code"; Text[200])
        {
            Caption = 'Asset Code';
            DataClassification = CustomerContent;
        }
    }
}
