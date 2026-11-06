report 60108 "GSSTax Invoice-Trans Continent"
{
    // //nc-101 :: code added for customer phone and city
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/Reports/Layouts/Tax Invoice - Trans Continent.rdl';
    Caption = 'Tax Invoice - Trans Continent';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.")ORDER(Ascending);
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";

            column(Picture; CompInfo.Picture)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddre; CompInfo.Address + CompInfo."Address 2" + ' Phone No. : ' + CompInfo."Phone No.")
            {
            }
            column(CompTel; CompInfo."Phone No.")
            {
            }
            column(CompFax; CompInfo."Fax No.")
            {
            }
            column(CompTRNNo; CompInfo."VAT Registration No.")
            {
            }
            column(CustomerName; CustLegal)
            {
            }
            column(Addresse; CustAddress)
            {
            }
            column(Phone; CustPhone)
            {
            }
            column(InvoiceNo; "Sales Invoice Header"."No.")
            {
            }
            column(CustomerNo; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(Deliveryref; ShipmentNo)
            {
            }
            column(DeliveryDate; ShipmentDate)
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(ShiptoAddress; "Ship-to Address" + ' ' + "Ship-to Address 2")
            {
            }
            column(ShiptoCity; "Ship-to City")
            {
            }
            column(CustTRNNo; "VAT Registration No.")
            {
            }
            column(Date; "Posting Date")
            {
            }
            column(CustomerPO; "Order No.")
            {
            }
            column(PaymentTerms; "Payment Terms Code")
            {
            }
            column(TotalINaed; TTAmnt)
            {
            }
            column(AmountInwords; AmountInwords)
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(CompanyShortCode; CompInfo."GSSCompany Shortcode")
            {
            }
            column(ExtDocNo; "Sales Invoice Header"."External Document No.")
            {
            }
            column(ContactPerson; ContactPerson)
            {
            }
            column(RevCh; RevCh)
            {
            }
            column(PaymentTermsDesc; PaymentTermsDesc)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(Sno; Slno)
                {
                }
                column(Description2_SalesInvoiceLine; "Sales Invoice Line"."Description 2")
                {
                }
                /* itos 
                column(ManfItemNo_SalesInvoiceLine;"Sales Invoice Line"."Manf. Item No.")
                {
                }
                column(ManfItemDesc_SalesInvoiceLine;"Sales Invoice Line"."Manf. Item Desc.")
                {
                }
                */
                column(ItemNo; "Sales Invoice Line"."No.")
                {
                }
                column(ItemDescription; Descr)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit; "Unit of Measure Code")
                {
                }
                column(Total; UnitPrice * Quantity)
                {
                }
                column(UnitPrice; UnitPrice)
                {
                }
                column(Discount; Discount)
                {
                }
                column(DiscAmt; DiscAmt)
                {
                }
                column(AmtInclVAT; AmntInclVAT)
                {
                }
                column(VATRate; "VAT %")
                {
                }
                column(TotalExclVAT; UnitPrice * Quantity - DiscAmt)
                {
                }
                column(VATAmt; AmntInclVAT - (UnitPrice * Quantity - DiscAmt))
                {
                }
                trigger OnAfterGetRecord();
                begin
                    if "Sales Invoice Line"."No." <> '' then Slno:=Slno + 1;
                    if Cust.Contact = '' then begin
                        RecContact.RESET;
                        RecContact.SETRANGE(RecContact."No.", "Sales Invoice Header"."Sell-to Contact No.");
                        if RecContact.FINDFIRST then ContactPerson:=RecContact.Name;
                    end
                    else
                    begin
                        ContactPerson:=Cust.Contact;
                    end;
                    RecGLSetup.RESET;
                    if RecGLSetup.GET then LocalCurr:=RecGLSetup."LCY Code";
                    if CurrencyFilter <> '' then begin
                        RecCurrency.RESET;
                        RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                        if RecCurrency.FIND('+')then begin
                            //   Amnt := ("Sales Invoice Line".Amount) * (RecCurrency."Exchange Rate Amount"/RecCurrency."Relational Exch. Rate Amount");
                            Amnt:=Amount * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            AmntInclVAT:="Amount Including VAT" * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            DiscAmt:=("Line Discount Amount" + "Inv. Discount Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            UnitPrice:="Sales Invoice Line"."Unit Price" * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                        end end
                    else
                    begin
                        //  Amnt := "Sales Invoice Line".Amount;
                        Amnt:=Amount;
                        AmntInclVAT:="Amount Including VAT";
                        DiscAmt:="Line Discount Amount" + "Inv. Discount Amount";
                        UnitPrice:="Sales Invoice Line"."Unit Price";
                    end;
                    if Type = Type::Item then begin
                        if ItemRec.GET("No.")then Descr:=ItemRec.Description + ItemRec."Description 2" //itos + ItemRec."Description 3"
 end
                    else
                    begin
                        Descr:="Sales Invoice Line".Description;
                    end;
                /*
                    RecSalesInv.RESET;
                    RecSalesInv.SETRANGE(RecSalesInv."Document No.","Sales Invoice Header"."No.");
                    IF RecSalesInv.FINDFIRST THEN BEGIN
                    REPEAT
                      Discount+=RecSalesInv."Line Discount Amount";
                    UNTIL
                    RecSalesInv.NEXT =0;
                    END;
                    */
                end;
                trigger OnPreDataItem();
                begin
                    Amnt:=0;
                    Discount:=0;
                end;
            }
            trigger OnAfterGetRecord();
            begin
                "Sales Invoice Header".CALCFIELDS("Sales Invoice Header".Amount, "Sales Invoice Header"."Amount Including VAT");
                "Total Amount":="Sales Invoice Header"."Amount Including VAT"; //GSS changed from amount to amount including vat
                if CurrencyFilter <> '' then begin
                    RecCurrency.RESET;
                    RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                    if RecCurrency.FIND('+')then TTAmnt:=ROUND(("Total Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount"), 0.01, '=');
                end
                else
                begin
                    TTAmnt:="Total Amount";
                end;
                SalesShip.RESET;
                if "Sales Invoice Header"."Order No." <> '' then begin
                    SalesShip.SETRANGE(SalesShip."Order No.", "Sales Invoice Header"."Order No.");
                    if SalesShip.FINDFIRST then begin
                        ShipmentNo:=SalesShip."No.";
                        ShipmentDate:=SalesShip."Posting Date";
                    end;
                end;
                RecGLSetup.RESET;
                if RecGLSetup.GET then LocalCurr:=RecGLSetup."LCY Code";
                //nc-101 begins
                Cust.RESET;
                Cust.SETRANGE(Cust."No.", "Sales Invoice Header"."Sell-to Customer No.");
                if Cust.FINDFIRST then begin
                    CustPhone:=Cust."Phone No.";
                    CustAddress:=Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City + ' ' + Cust."Country/Region Code";
                    // itos  if Cust."Legal Name" = '' then
                    CustLegal:=Cust.Name;
                    /* itos  else
                         CustLegal := Cust."Legal Name"; */
                    if "VAT Registration No." = '' then "VAT Registration No.":=Cust."VAT Registration No.";
                end;
                //nc-101 ends
                if "Sales Invoice Header"."Currency Code" = '' then begin
                    if CurrencyFilter = '' then begin
                        CurrCode:=LocalCurr end
                    else
                    begin
                        CurrCode:=CurrencyFilter end;
                end
                else
                    CurrCode:="Currency Code";
                Check.FormatNoText(Amt, TTAmnt, '');
                AmountInwords:=Amt[2] + Amt[1];
                PayTermRec.RESET;
                PayTermRec.SETRANGE(Code, "Sales Invoice Header"."Payment Terms Code");
                if PayTermRec.FINDFIRST then PaymentTermsDesc:=PayTermRec.Description;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field("Currency Code"; CurrencyFilter)
                    {
                        ApplicationArea = All;
                        Visible = false;
                    /*
                          trigger OnLookup(VAR Text: Text): Boolean;
                          begin
                              if PAGE.RUNMODAL(PAGE::Currencies, RecCurr) = ACTION::LookupOK then begin
                                  CurrencyFilter := RecCurr.Code;
                              end;
                          end;
                          */
                    }
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
    trigger OnInitReport();
    begin
        RevCh:='No';
    end;
    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        Check.InitTextVariable;
    end;
    var Cust: Record Customer;
    CustPhone: Code[30];
    Slno: Integer;
    CompInfo: Record "Company Information";
    "Total Amount": Decimal;
    Amt: array[2]of Text;
    AmountInwords: Text;
    Check: Report Check;
    RecCurrency: Record "Currency Exchange Rate";
    RecCurr: Record Currency;
    CurrencyFilter: Code[10];
    Amnt: Decimal;
    AmntInclVAT: Decimal;
    DiscAmt: Decimal;
    RecGLSetup: Record "General Ledger Setup";
    LocalCurr: Code[20];
    TTAmnt: Decimal;
    CurrCode: Code[20];
    ItemRec: Record Item;
    Descr: Text;
    ContactPerson: Text[100];
    RecContact: Record Contact;
    SalesShip: Record "Sales Shipment Header";
    ShipmentNo: Code[20];
    CustAddress: Text[100];
    UnitPrice: Decimal;
    RecSalesInv: Record "Sales Invoice Line";
    Discount: Decimal;
    ShipmentDate: Date;
    RevCh: Text;
    CustLegal: Code[250];
    PaymentTermsDesc: Text;
    PayTermRec: Record "Payment Terms";
}
