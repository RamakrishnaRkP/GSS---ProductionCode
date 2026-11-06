report 60110 "GSSSales Quote Original"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Sales Quote Original.rdl';
    Caption = 'Sales Quote - Original';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            CalcFields = Amount;
            DataItemTableView = SORTING("No.")ORDER(Ascending);

            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddrese; CompInfo.Address + 'Tel :' + '  ' + CompInfo."Phone No." + ' Fax :' + CompInfo."Fax No.")
            {
            }
            column(Picture; CompInfo.Picture)
            {
            }
            column(CompPhone; CompInfo."Phone No.")
            {
            }
            column(CompFax; CompInfo."Fax No.")
            {
            }
            column(DeliveryNo; "Sales Header"."No.")
            {
            }
            column(DeliveryDate; FORMAT("Sales Header"."Document Date"))
            {
            }
            column(SalesOrderNo; "Sales Header"."No.")
            {
            }
            column(CustomerReference; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(Customername; "Sales Header"."Sell-to Customer Name")
            {
            }
            //itos start
            /* column(QuoteValidityPeriod_SalesHeader; "Sales Header"."Quote Validity Period")
             {
             }
             column(DeliveryTerms_SalesHeader; "Sales Header"."Delivery Terms")
             {
             }
             column(QuoteRevisionNumber_SalesHeader; "Sales Header"."Quote Revision Number")
             {
             } itos end*/
            column(CustomerAddresse; "Sales Header"."Sell-to Address")
            {
            }
            column(CustomerContact; Cust."Name 2")
            {
            }
            column(InvoiceDiscount; "Sales Header"."Invoice Discount Value")
            {
            }
            column(SalesAmount; "Sales Header".Amount)
            {
            }
            column(SalespersonName; Salesperson.Name)
            {
            }
            column(PhoneNo; Cust."Phone No.")
            {
            }
            column(FaxNo; Cust."Fax No.")
            {
            }
            column(ContactName; RecContact.Name)
            {
            }
            column(PSubject; SalesQuoteSubject)
            {
            }
            column(SJobTitle; Salesperson."Job Title")
            {
            }
            column(SEmail; Salesperson."E-Mail")
            {
            }
            column(SPhoneNo; Salesperson."Phone No.")
            {
            }
            column(CurrencyCode; CurrencyCode)
            {
            }
            column(PaymentDescription; PTerm)
            {
            }
            column(ShipmentDescription; DTerm)
            {
            }
            column(HidePartNo; HidePartNo)
            {
            }
            column(Days; Days)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")ORDER(Ascending);

                /* TODO Ask Traun sir
                column(Group; "Sales Line".Group)
                {
                }
                column(SlNo; "Sales Line"."Group Nos")
                {
                }*/
                column(PartNo; "Sales Line"."No.")
                {
                }
                column(Description; Descr)
                {
                }
                /*itos TODO : ASK Traun sir
                column(SNNo; "Sales Line"."Group Nos")
                {
                }
                */
                column(Qty; "Sales Line".Quantity)
                {
                }
                column(Unitprice; "Sales Line"."Unit Price")
                {
                }
                column(LineAmount; "Sales Line"."Line Amount")
                {
                }
                //ITOS Start
                /*  column(ManfItemNo_SalesLine; "Sales Line"."Manf. Item No.")
                  {
                  }
                  column(ManfItemDesc_SalesLine; "Sales Line"."Manf. Item Desc.")
                  {
                  } ITOS end */
                trigger OnAfterGetRecord();
                begin
                    SlNo:=SlNo + 1;
                    if Item.GET("Sales Line"."No.")then Descr:=Item.Description + Item."Description 2" // itos start + Item."Description 3" //itos end
                    else
                        Descr:="Sales Line".Description;
                end;
            }
            trigger OnAfterGetRecord();
            begin
                if Salesperson.GET("Sales Header"."Salesperson Code")then;
                if Cust.GET("Sales Header"."Sell-to Customer No.")then;
                RecContact.RESET;
                if RecContact.GET("Sales Header"."Sell-to Contact No.")then;
                RecGLSetup.GET;
                if "Sales Header"."Currency Code" = '' then CurrencyCode:=RecGLSetup."LCY Code"
                else
                    CurrencyCode:="Sales Header"."Currency Code";
                RecPayment.RESET;
                if RecPayment.GET("Sales Header"."Payment Terms Code")then;
                RecShipment.RESET;
                if RecShipment.GET("Sales Header"."Shipment Method Code")then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Sales Quote Subject"; SalesQuoteSubject)
                {
                    ApplicationArea = All;
                }
                field(Validity; Days)
                {
                    ApplicationArea = All;
                }
                field("Hide Part No"; HidePartNo)
                {
                    ApplicationArea = All;
                }
                field("Payment Terms"; PTerm)
                {
                    ApplicationArea = All;
                }
                field("Delivery Terms"; DTerm)
                {
                    ApplicationArea = All;
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
    end;
    var CompInfo: Record "Company Information";
    SlNo: Integer;
    Item: Record Item;
    SerielNo: Code[20];
    Cust: Record Customer;
    CustContact: Code[20];
    Salesperson: Record "Salesperson/Purchaser";
    Descr: Text;
    RecContact: Record Contact;
    PSubject: Text[150];
    RecGLSetup: Record "General Ledger Setup";
    CurrencyCode: Code[20];
    RecPayment: Record "Payment Terms";
    RecShipment: Record "Shipment Method";
    HidePartNo: Boolean;
    Days: Code[10];
    SalesQuoteSubject: Text[250];
    PTerm: Text[250];
    DTerm: Text[250];
}
