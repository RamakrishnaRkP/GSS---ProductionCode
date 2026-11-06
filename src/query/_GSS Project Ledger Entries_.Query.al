query 60102 "GSS Project Ledger Entries"
{
    QueryType = API;
    APIPublisher = 'GSS';
    APIGroup = 'JobLedgerEntries';
    APIVersion = 'v1.0';
    EntityName = 'JobLedgerEntries';
    EntitySetName = 'JobLedgerEntries';

    elements
    {
        dataitem(Job_Ledger_Entry;
            "Job Ledger Entry")
        {
            DataItemTableFilter = "Entry Type"=const(Usage);

            column(Job_No_;
                "Job No.")
            {
            }
            column(Job_Posting_Group;
                "Job Posting Group")
            {
            }
            column(Revenue;
                "Line Amount (LCY)")
            {
            }
            column(Posting_Date;
                "Posting Date")
            {
            }
            column(Document_No_;
                "Document No.")
            {
            }
            column(Global_Dimension_1_Code;
                "Global Dimension 1 Code")
            {
            }
            column(Global_Dimension_2_Code;
                "Global Dimension 2 Code")
            {
            }
            column(Quantity;
                Quantity)
            {
            }
            column(Unit_Cost__LCY_;
                "Unit Cost (LCY)")
            {
            }
            column(Total_Cost__LCY_;
                "Total Cost (LCY)")
            {
            }
            column(Location_Code;
                "Location Code")
            {
            }
            column(Type;
                Type)
            {
            }
            column(No_;
                "No.")
            {
            }
            column(External_Document_No_;
                "External Document No.")
            {
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
}
