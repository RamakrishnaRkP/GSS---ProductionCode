query 60101 "GSS GL Entries"
{
    QueryType = API;
    APIPublisher = 'GSS';
    APIGroup = 'GLEntries';
    APIVersion = 'v1.0';
    EntityName = 'GLEntries';
    EntitySetName = 'GLEntries';

    elements
    {
        dataitem(G_L_Entry;
            "G/L Entry")
        {
            column(Job_No_;
                "Job No.")
            {
            }
            column(InvoiceDate;
                "Posting Date")
            {
            }
            column(Global_Dimension_1_Code;
                "Global Dimension 1 Code")
            {
            }
            column(G_L_Account_No_;
                "G/L Account No.")
            {
            }
            column(Amount;
                Amount)
            {
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
}
