tableextension 60180 Contact_Ext extends Contact
{
    fields
    {
        field(50000; "Company Name New"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }
}
