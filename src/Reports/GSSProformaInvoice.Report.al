report 60123 GSSProformaInvoice
{
    // //nc-101 :: code added for customer phone and city
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GBM Proforma Invoice.rdl';
    PreviewMode = PrintLayout;
    Caption = 'Proforma Invoice';

    dataset
    {
        dataitem(Job; "job")
        {
            DataItemTableView = SORTING("No.")ORDER(Ascending);
            RequestFilterFields = "No.", "Bill-to Customer No.", "Creation Date";

            column(Picture; CompInfo.Picture)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddre; CompInfo.Address + ' Phone No. : ' + CompInfo."Phone No." + ' Fax No. : ' + CompInfo."Fax No.")
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
            column(CustomerName; "Job"."Bill-to Name")
            {
            }
            column(Addresse; CustAddress)
            {
            }
            column(Phone; CustPhone)
            {
            }
            column(InvoiceNo; Job."No.")
            {
            }
            column(CustomerNo; "job"."Bill-to Customer No.")
            {
            }
            column(Deliveryref; ShipmentNo)
            {
            }
            column(Date; Job."Creation Date")
            {
            }
            column(CustomerPO; "Job"."No.")
            {
            }
            column(PaymentTerms; JobPmtTerms)
            {
            }
            column(CustTRNNo; Cust."VAT Registration No.")
            {
            }
            column(TotalINaed; TTAmnt)
            {
            }
            column(TTAmntVAT; TTAmntVAT)
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(CompanyShortCode; CompInfo."GSSCompany Shortcode")
            {
            }
            column(ExtDocNo; Job."External Document No.")
            {
            }
            column(ContactPerson; ContactPerson)
            {
            }
            column(BankCode; RecBank."No.")
            {
            }
            column(BankName; RecBank.Name)
            {
            }
            column(BankBranch; RecBank."Bank Branch No.")
            {
            }
            column(BankAccNo; RecBank."Bank Account No.")
            {
            }
            column(BankSwift; RecBank."SWIFT Code")
            {
            }
            column(BankIBAN; RecBank.IBAN)
            {
            }
            column(BankName2; RecBank."Name 2")
            {
            }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No."=field("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")WHERE(Quantity=FILTER(<>0), "Line Type"=filter(Billable|"Both Budget and Billable"));

                column(AmountInwords; AmountInwords)
                {
                }
                column(Sno; Slno)
                {
                }
                column(ItemNo; "Job Planning Line"."No.")
                {
                }
                column(ItemDescription; Descr)
                {
                }
                column(Quantity; "Job Planning Line".Quantity)
                {
                }
                column(Disc; "Line Discount Amount" + InvDiscountAmount)
                {
                }
                column(Unit; "Job Planning Line"."Unit of Measure Code")
                {
                }
                column(Total; Amnt)
                {
                }
                column(AmtInclVAT; AmtInclVAT)
                {
                }
                column(UnitPrice; UnitPrice)
                {
                }
                column(Description2; "Job Planning Line"."Description 2")
                {
                }
                column(Description; StrSubstNo('%1 %2', "Job Planning Line".Description, "Job Planning Line"."Description 2"))
                {
                }
                trigger OnAfterGetRecord();
                var
                    VatAmt: Decimal;
                    VATPer: Decimal;
                begin
                    Clear(VatAmt);
                    Slno:=Slno + 1;
                    RecContact.RESET;
                    RecContact.SETRANGE(RecContact."No.", job."Bill-to Contact No.");
                    if RecContact.FINDFIRST then ContactPerson:=RecContact.Name;
                    RecGLSetup.RESET;
                    if RecGLSetup.GET then LocalCurr:=RecGLSetup."LCY Code";
                    /*
                 IF ("Sales Header"."Currency Code" = LocalCurr)
                   OR ("Sales Header"."Currency Code" = '') AND ("Sales Header"."Currency Code" = LocalCurr) THEN BEGIN
                   Amnt := "Sales Line".Amount;
                 END;
                     */
                    Clear(VATPer);
                    Clear(VatAmt);
                    CLEAR(AmtInclVAT);
                    clear(Amnt);
                    // clear(CurrencyFilter);
                    VATPer:=GetVATPercent(Cust."VAT Bus. Posting Group", GetProductPostingGroup("Job Planning Line"));
                    if CurrencyFilter <> '' then begin
                        RecCurrency.RESET;
                        RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                        if RecCurrency.FIND('-')then begin
                            Curr.Get(RecCurrency."Currency Code");
                            Amnt:=Round(("Job Planning Line"."Line Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount"), Curr."Amount Rounding Precision");
                            if VATPer <> 0 then VatAmt:=Round((Amnt * VATPer) / 100, Curr."Amount Rounding Precision");
                            //AmtInclVAT := ("Job Planning Line"."Amount Including VAT") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            AmtInclVAT:=("Job Planning Line"."Line Amount" + "Job Planning Line"."VAT Line Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            UnitPrice:="Job Planning Line"."Unit Price" * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount");
                            AmtInclVAT:=Amnt + VatAmt;
                            UnitPrice:=round("Job Planning Line"."Unit Price" * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount"), Curr."Unit-Amount Rounding Precision");
                        end end
                    else
                    begin
                        RecGLSetup.Get();
                        Amnt:="Job Planning Line"."Line Amount";
                        if VATPer <> 0 then VatAmt:=Round((Amnt * VATPer) / 100, RecGLSetup."Amount Rounding Precision");
                        UnitPrice:="Job Planning Line"."Unit Price";
                        AmtInclVAT:="Job Planning Line"."Line Amount" + "Job Planning Line"."VAT Line Amount";
                        AmtInclVAT:=Amnt + VatAmt;
                    end;
                    if Type = Type::Item then begin
                        if ItemRec.GET("No.")then Descr:=ItemRec.Description + ItemRec."Description 2" //ch + ItemRec."Description 3"
 end
                    else
                    begin
                        Descr:="Job Planning Line".Description + "Job Planning Line"."Description 2";
                    end;
                    TTAmntVAT+=AmtInclVAT;
                    Check.FormatNoText(Amt, TTAmntVAT, CurrCode);
                    AmountInwords:=Amt[2] + Amt[1];
                end;
                trigger OnPreDataItem();
                begin
                    Amnt:=0;
                end;
            }
            trigger OnAfterGetRecord();
            begin
                //TS-
                // CLEAR(TTAmntVAT);
                // Job.CALCFIELDS(Job.Amount, Job."Amount Including VAT");
                // "Total Amount" := Job.Amount;
                // if CurrencyFilter <> '' then begin
                //     RecCurrency.RESET;
                //     RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                //     if RecCurrency.FIND('-') then begin
                //         TTAmnt := ROUND(("Total Amount") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount"), 0.01, '=');
                //         TTAmntVAT := ROUND((Job."Amount Including VAT") * (RecCurrency."Exchange Rate Amount" / RecCurrency."Relational Exch. Rate Amount"), 0.01, '=');
                //     end;
                // end else begin
                //     TTAmnt := "Total Amount";
                //     TTAmntVAT := Job."Amount Including VAT";
                // end;
                //TS+
                /*
                SalesShip.RESET;
                SalesShip.SETRANGE(SalesShip."Order No.","Sales Header"."Order No.");
                IF SalesShip.FINDFIRST THEN
                  ShipmentNo:=SalesShip."No.";
                 */
                RecGLSetup.RESET;
                if RecGLSetup.GET then LocalCurr:=RecGLSetup."LCY Code";
                //nc-101 begins
                Cust.RESET;
                Cust.SETRANGE(Cust."No.", job."Bill-to Customer No.");
                if Cust.FINDFIRST then CustPhone:=Cust."Phone No.";
                CustAddress:=Cust.City + ' ' + Cust."Country/Region Code";
                //nc-101 ends
                //TS-
                if PaymentTerms = '' then begin
                    if "Payment Terms Code" <> '' then JobPmtTerms:="Payment Terms Code"
                    else
                        JobPmtTerms:=Cust."Payment Terms Code";
                end
                else
                    JobPmtTerms:=PaymentTerms;
                //TS+
                if CurrencyFilter = '' then begin
                    CurrCode:=LocalCurr end
                else
                begin
                    CurrCode:=CurrencyFilter end;
                //TS-
                // Check.FormatNoText(Amt, TTAmntVAT, '');
                // AmountInwords := Amt[2] + Amt[1];
                Clear(TTAmntVAT);
                Clear(Amt);
                //TS+
                RecBank.RESET;
                if RecBank.GET(BankCode)then;
                if RecBank."No." = '' then begin
                    RecBank."Name 2":=CompInfo."Bank Name";
                    RecBank.IBAN:=CompInfo.IBAN;
                    RecBank."Bank Account No.":=CompInfo."Bank Account No.";
                    RecBank."Bank Branch No.":=CompInfo."Bank Branch No.";
                    RecBank."SWIFT Code":=CompInfo."SWIFT Code";
                end;
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

                        trigger OnLookup(var Text: Text): Boolean;
                        begin
                            if PAGE.RUNMODAL(PAGE::Currencies, RecCurr) = ACTION::LookupOK then begin
                                CurrencyFilter:=RecCurr.Code;
                            end;
                        end;
                    }
                    field("Payment Terms"; PaymentTerms)
                    {
                        ApplicationArea = All;
                    }
                    field("Bank Code"; BankCodeFilter)
                    {
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean;
                        begin
                            if PAGE.RUNMODAL(PAGE::"Bank Account List", RecBank) = ACTION::LookupOK then begin
                                BankCodeFilter:=RecBank."No.";
                            end;
                        end;
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
    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        Check.InitTextVariable;
    end;
    var Cust: Record Customer;
    CustPhone: Code[20];
    Slno: Integer;
    CompInfo: Record "Company Information";
    "Total Amount": Decimal;
    Amt: array[2]of Text;
    AmountInwords: Text;
    Check: Report Check;
    RecCurrency: Record "Currency Exchange Rate";
    RecCurr: Record Currency;
    CurrencyFilter: Code[10];
    BankCodeFilter: Code[20];
    Amnt: Decimal;
    RecGLSetup: Record "General Ledger Setup";
    LocalCurr: Code[20];
    TTAmnt: Decimal;
    TTAmntVAT: Decimal;
    CurrCode: Code[20];
    ItemRec: Record Item;
    Descr: Text;
    ContactPerson: Text[100];
    RecContact: Record Contact;
    SalesShip: Record "Sales Shipment Header";
    ShipmentNo: Code[20];
    CustAddress: Text[100];
    UnitPrice: Decimal;
    BankIBAN: Text[50];
    BankSwift: Text[50];
    BankAccNo: Text[50];
    BankBranch: Text[100];
    BankName: Text[100];
    RecBank: Record "Bank Account";
    AmtInclVAT: Decimal;
    PaymentTerms: Text;
    InvDiscountAmount: Integer;
    BankCode: Code[20];
    JobPmtTerms: Text;
    Curr: Record Currency;
    local procedure GetProductPostingGroup(var JPL: Record "Job Planning Line"): Code[20];
    var
        VPPG: Code[20];
        Item1: Record Item;
        Resource1: Record Resource;
        GLAcc1: Record "G/L Account";
    begin
        Clear(VPPG);
        Clear(ItemRec);
        if JPL.Type = JPL.Type::Item then begin
            if Item1.GET(JPL."No.")then VPPG:=Item1."VAT Prod. Posting Group";
        end
        else if JPL.Type = JPL.Type::Resource then begin
                if Resource1.Get(JPL."No.")then VPPG:=Resource1."VAT Prod. Posting Group";
            end
            else IF JPL.Type = JPL.Type::"G/L Account" then begin
                    IF GLAcc1.Get(JPL."No.")then VPPG:=GLAcc1."VAT Prod. Posting Group";
                end;
        Exit(VPPG);
    end;
    local procedure GetVATPercent(GenBusPostingGroup: Code[20]; VATProductPostingGroup: Code[20]): Decimal var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if VATPostingSetup.Get(GenBusPostingGroup, VATProductPostingGroup)then exit(VATPostingSetup."VAT %");
        exit(0);
    end;
}
