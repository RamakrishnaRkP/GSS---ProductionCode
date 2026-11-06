report 60190 "Applied Entries List"
{
    Caption = 'Customer Applied Entries';
    RDLCLayout = './src/Reports/Layouts/AppliedEntriesList.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(CLE1; "Cust. Ledger Entry")
        {
            column(ReceiptDate; Format("Posting Date"))
            {
            }
            column(ReceiptNo; "Document No.")
            {
            }
            column(AppliedAmount; AppliedAmount)
            {
            }
            dataitem(DCLE; "Detailed Cust. Ledg. Entry")
            {
                DataItemLinkReference = CLE1;
                DataItemLink = "Applied Cust. Ledger Entry No."=field("Entry No.");

                column(Entry_No_; "Entry No.")
                {
                }
                column(Customer_No_; "Customer No.")
                {
                }
                column(CustomerName; CustRec.Name)
                {
                }
                dataitem(CLE2; "Cust. Ledger Entry")
                {
                    DataItemLinkReference = DCLE;
                    DataItemLink = "Entry No."=field("Cust. Ledger Entry No.");

                    column(InvoiceDate; Format("Posting Date"))
                    {
                    }
                    column(InvoiceNo; "Document No.")
                    {
                    }
                    column(Amount; Amount)
                    {
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    if DCLE."Cust. Ledger Entry No." = CLE1."Entry No." then CurrReport.Skip();
                    if CustRec.Get(DCLE."Customer No.")then;
                end;
            }
            trigger OnPreDataItem()
            begin
                if((FromDate <> 0D) and (ToDate <> 0D))then SetRange("Posting Date", FromDate, ToDate)
                else if((FromDate <> 0D) and (ToDate = 0D))then SetRange("Posting Date", FromDate)
                    else if((FromDate = 0D) and (ToDate <> 0D))then SetRange("Posting Date", 0D, ToDate);
                SetFilter("Document Type", '=%1', "Document Type"::" ");
            end;
            trigger OnAfterGetRecord()
            begin
                Clear(AppliedAmount);
                CLE1.CalcFields("Amount (LCY)");
                if CLE1."Amount (LCY)" < 0 then AppliedAmount:=CLE1."Amount (LCY)" * -1
                else
                    AppliedAmount:=CLE1."Amount (LCY)";
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var FromDate: Date;
    ToDate: Date;
    CustRec: Record Customer;
    AppliedAmount: Decimal;
}
