report 60107 "GSSTax Invoice"
{
    // //nc-101 :: code added for customer phone and city
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Tax Invoice.rdl';
    Caption = 'Tax Invoice';
    UsageCategory = ReportsAndAnalysis;
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
            column(CompAddre; CompInfo.Address + CompInfo."Address 2" + ' Phone No. : ' + CompInfo."Phone No." + ' Fax No. : ' + CompInfo."Fax No.")
            {
            }
            column(CompTel; CompInfo."Phone No.")
            {
            }
            column(CompFax; CompInfo."Fax No.")
            {
            }
            column(CompTRNNo; CompTRN)
            {
            }
            column(CustomerName; "Sell-to Customer Name")
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
            column(SeqNo; SeqNo)
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
            column(AccountNoAED; CompInfo."Account No. (AED)")
            {
            }
            column(AccountNoUSD; CompInfo."Account No. (USD)")
            {
            }
            column(IBANAED; CompInfo."IBAN (AED)")
            {
            }
            column(IBANUSD; CompInfo."IBAN (USD)")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(Sno; Slno)
                {
                }
                column(Description2_SalesInvoiceLine; StrSubstNo('%1 %2', "Sales Invoice Line"."Description", "Sales Invoice Line"."Description 2"))
                {
                }
                column(ItemNo; "Sales Invoice Line"."No.")
                {
                }
                //TODO ASK ASH change the Manf.ItemNo.
                //  column(ManfItemNo_SalesInvoiceLine; "Sales Invoice Line"."Manf. Item No.")
                // {
                // }
                // column(ManfItemDesc_SalesInvoiceLine; "Sales Invoice Line"."Manf. Item Desc.")
                //{
                //}
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
                    if "Sales Invoice Line".Amount <> 0 then SeqNo+=1;
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
                        //TS-04-Apr-2022-
                        /*
                        RecCurrency.RESET;
                        RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                        if RecCurrency.FIND('+') then begin
                            //   Amnt := ("Sales Invoice Line".Amount) * (RecCurrency."Exchange Rate Amount"/RecCurrency."Relational Exch. Rate Amount");
                            Amnt := Amount * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            AmntInclVAT := "Amount Including VAT" * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            DiscAmt := ("Line Discount Amount" + "Inv. Discount Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            UnitPrice := "Sales Invoice Line"."Unit Price" * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                        end
                        */
                        RecCurrency.RESET;
                        RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                        if RecCurrency.FIND('+')then begin
                            Amnt:=Amount * (RecCurrency."Exchange Rate Amount" / RelationalExchRate);
                            AmntInclVAT:="Amount Including VAT" * (RecCurrency."Exchange Rate Amount" / RelationalExchRate);
                            DiscAmt:=("Line Discount Amount" + "Inv. Discount Amount") * (RecCurrency."Exchange Rate Amount" / RelationalExchRate);
                            UnitPrice:="Sales Invoice Line"."Unit Price" * (RecCurrency."Exchange Rate Amount" / RelationalExchRate);
                        end //TS-04-Apr-2022+
                    end
                    else
                    begin
                        //  Amnt := "Sales Invoice Line".Amount;
                        Amnt:=Amount;
                        AmntInclVAT:="Amount Including VAT";
                        DiscAmt:="Line Discount Amount" + "Inv. Discount Amount";
                        UnitPrice:="Sales Invoice Line"."Unit Price";
                    end;
                    if Type = Type::Item then begin
                        if ItemRec.GET("No.")then Descr:=ItemRec.Description + ItemRec."Description 2" //TODO change + ItemRec."Description 3"
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
                    //TS-04-Apr-2022-
                    /*
                    RecCurrency.RESET;
                    RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                    if RecCurrency.FIND('+') then
                        TTAmnt := ROUND(("Total Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount"), 0.01, '=');
                    */
                    RecCurrency.RESET;
                    RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                    if RecCurrency.FIND('+')then TTAmnt:=ROUND(("Total Amount") * (RecCurrency."Exchange Rate Amount" / RelationalExchRate), 0.01, '=');
                //TS-04-Apr-2022+
                end
                else
                begin
                    TTAmnt:="Total Amount";
                end;
                SalesShip.RESET;
                //ITOS-
                // if "Sales Invoice Header"."Order No." <> '' then begin
                //     SalesShip.SETRANGE(SalesShip."Order No.", "Sales Invoice Header"."Order No.");
                //     if SalesShip.FINDFIRST then begin
                //         ShipmentNo := SalesShip."No.";
                //         ShipmentDate := SalesShip."Posting Date";
                //     end;
                // end;
                Clear(ShipmentNo);
                Clear(ShipmentDate);
                GetDeliveryNoteNo("Sales Invoice Header");
                //ITOS+
                RecGLSetup.RESET;
                if RecGLSetup.GET then LocalCurr:=RecGLSetup."LCY Code";
                //nc-101 begins
                /*Cust.RESET;
                Cust.SETRANGE(Cust."No.", "Sales Invoice Header"."Sell-to Customer No.");
                if Cust.FINDFIRST then begin
                    CustPhone := Cust."Phone No.";
                    CustAddress := Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City + ' ' + Cust."Country/Region Code"; //ITOS
                    if Cust."Legal Name" = '' then
                        CustLegal := Cust.Name
                    else
                        CustLegal := Cust."Legal Name";
                    if "VAT Registration No." = '' then
                        "VAT Registration No." := Cust."VAT Registration No.";
                end;*/
                cust.Reset();
                cust.SETRANGE(Cust."No.", "Sales Invoice Header"."Sell-to Customer No.");
                if Cust.FINDFIRST then begin
                    CustPhone:=Cust."Phone No.";
                    CustAddress:=Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City + ' ' + Cust."Country/Region Code"; //ITOS
                    CustLegal:=Cust.Name;
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
                //TS-04-Apr-2022-
                if CurrencyFilter <> '' then CurrCode:=CurrencyFilter;
                //TS-04-Apr-2022+
                Check.FormatNoText(Amt, TTAmnt, '');
                AmountInwords:=Amt[2] + Amt[1];
                PayTermRec.RESET;
                PayTermRec.SETRANGE(Code, "Sales Invoice Header"."Payment Terms Code");
                if PayTermRec.FINDFIRST then PaymentTermsDesc:=PayTermRec.Description;
                if "Sales Invoice Header"."Posting Date" < 20250227D then CompTRN:='100570386100003'
                else
                    CompTRN:=CompInfo."VAT Registration No.";
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
                        Visible = true;
                        TableRelation = Currency;

                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            Clear(RelationalExchRate);
                            Clear(RecCurrency);
                            RecCurrency.RESET;
                            RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                            if RecCurrency.FIND('+')then RelationalExchRate:=RecCurrency."Relational Exch. Rate Amount";
                        end;
                    // trigger OnLookup(Text: Text): Boolean;
                    // begin
                    //     if PAGE.RUNMODAL(PAGE::Currencies, RecCurr) = ACTION::LookupOK then begin
                    //         CurrencyFilter := RecCurr.Code;
                    //     end;
                    // end;
                    }
                    field(RelationalExchRate; RelationalExchRate)
                    {
                        Caption = 'Currency Exch. Rate';
                        ApplicationArea = All;
                        Editable = CurrencyFilter <> '';
                        DecimalPlaces = 1: 6;
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
        CompanyShortcode:=CompInfo."GSSCompany Shortcode";
        Check.InitTextVariable;
    end;
    local procedure GetDeliveryNoteNo(var SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesInvLines: Record "Sales Invoice Line";
        JobPlanningLine: Record "Job Planning Line";
        DeliveryNoteNo: Text;
        JobUsageLink: Record "Job Usage Link";
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        Clear(DeliveryNoteNo);
        SalesInvLines.SetCurrentKey("Document No.", "Line No.");
        SalesInvLines.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLines.SetFilter("Job No.", '<>%1', '');
        SalesInvLines.SetFilter("Job Task No.", '<>%1', '');
        SalesInvLines.SetFilter("Job Contract Entry No.", '<>0');
        if SalesInvLines.FindFirst()then repeat Clear(JobPlanningLine);
                JobPlanningLine.SetCurrentKey("Job No.", "Job Task No.", "Line No.");
                JobPlanningLine.SetRange("Job No.", SalesInvLines."Job No.");
                JobPlanningLine.SetRange("Job Task No.", SalesInvLines."Job Task No.");
                JobPlanningLine.SetRange("Job Contract Entry No.", SalesInvLines."Job Contract Entry No.");
                JobPlanningLine.SetRange("Line Type", JobPlanningLine."Line Type"::"Both Budget and Billable");
                if JobPlanningLine.FindFirst()then repeat if DeliveryNoteNo = '' then begin
                            JobUsageLink.SetRange("Job No.", JobPlanningLine."Job No.");
                            JobUsageLink.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
                            JobUsageLink.SetRange("Line No.", JobPlanningLine."Line No.");
                            if JobUsageLink.FindSet then repeat if DeliveryNoteNo = '' then begin
                                        JobLedgerEntry.Get(JobUsageLink."Entry No.");
                                        if JobLedgerEntry."Entry Type" = JobLedgerEntry."Entry Type"::Usage then begin
                                            ShipmentDate:=JobLedgerEntry."Posting Date";
                                            ShipmentNo:=JobLedgerEntry."Document No.";
                                        end;
                                    end;
                                until(JobUsageLink.Next() = 0);
                        end;
                    until(JobPlanningLine.Next() = 0);
            until SalesInvLines.Next() = 0;
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
    RelationalExchRate: Decimal;
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
    CustAddress: Text[200];
    UnitPrice: Decimal;
    RecSalesInv: Record "Sales Invoice Line";
    Discount: Decimal;
    ShipmentDate: Date;
    RevCh: Text;
    CustLegal: Code[250];
    PaymentTermsDesc: Text;
    PayTermRec: Record "Payment Terms";
    SeqNo: Integer;
    CompanyShortcode: Code[20];
    CompTRN: Text[20];
}
