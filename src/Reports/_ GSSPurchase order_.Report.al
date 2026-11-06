report 60114 " GSSPurchase order"
{
    // NC-101 CODE MODIFIED
    // NC-102 CODE ADDED
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Purchase order GSS.rdl';
    Caption = 'Purchase Order';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")ORDER(Ascending);
            RequestFilterFields = "No.";

            column(SignAuth; SignAuth)
            {
            }
            column(ReportName; ReportName)
            {
            }
            column(Name; CompInfo.Name)
            {
            }
            column(Address; CompInfo.Address + ' Tel: ' + CompInfo."Phone No." + ' Fax : ' + CompInfo."Fax No.")
            {
            }
            column(Phone; CompInfo."Phone No.")
            {
            }
            column(Fax; CompInfo."Fax No.")
            {
            }
            column(Picture; CompInfo.Picture)
            {
            }
            column(TRNNo; CompInfo."VAT Registration No.")
            {
            }
            column(Vendname; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(VendAddre; "Purchase Header"."Buy-from Address")
            {
            }
            column(VendPhone; VendPhone)
            {
            }
            column(Vendfax; "Vend Fax")
            {
            }
            column(VendEmail; VendEmail1)
            {
            }
            column(VendTRN; VendTRN)
            {
            }
            column(Purchaseorder; "Purchase Header"."No.")
            {
            }
            /* itos 
            column(Saleesorder; "Sales Order")
            {
            }
             itos end */
            /* itos
           column(SONo_PurchaseHeader; "Purchase Header"."SO No.")
           {
           }
           itos end*/
            column(Date; "Order Date")
            {
            }
            column(Attend; RecContact.Name)
            {
            }
            column(PaymentTerms; PayTerms.Description)
            {
            }
            column(ShiptoName; "Purchase Header"."Ship-to Name")
            {
            }
            column(ShiptoAddress; "Purchase Header"."Ship-to Address" + ' ' + "Purchase Header"."Ship-to Address 2")
            {
            }
            column(ShiptoCity; "Purchase Header"."Ship-to City")
            {
            }
            column(CurrencyCode; CurrencyCode)
            {
            }
            column(SalesPersonNam; SalesPersonNam)
            {
            }
            column(CompanyShortcode; CompanyShortcode)
            {
            }
            column(expectedReceiptDate; "Purchase Header"."Requested Receipt Date")
            {
            }
            column(InvDiscAmout; "Purchase Header"."Invoice Discount Amount")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type"=FIELD("Document Type"), "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                column(Partno; "Purchase Line"."No.")
                {
                }
                /*itos
                column(GroupNos_PurchaseLine; "Purchase Line"."Group Nos")
                {
                }
                itos end */
                column(Description; Descr)
                {
                }
                column(Qty; "Purchase Line".Quantity)
                {
                }
                column(UnitPrice; "Purchase Line"."Direct Unit Cost")
                {
                }
                /* itos
                column(ManfItemNo; "Purchase Line"."Manf. Item No.")
                {
                }
                column(ManItemDesc; "Purchase Line"."Manf. Item Desc.")
                {
                } itos*/
                column(Total; "Purchase Line"."Line Amount")
                {
                }
                column(TotalAED; TotalAED)
                {
                }
                column(AmountInwords; amountInwords)
                {
                }
                column(SalesOrderNo; "Sales Order No.")
                {
                }
                column(VATRate; "VAT %")
                {
                }
                column(AmtwithVAT; AmtInclVAT)
                {
                }
                trigger OnAfterGetRecord();
                begin
                    if Type = Type::Item then begin
                        /* itos
                         if ItemRec.GET("No.") then begin
                             if not ItemRec."Print Descr. from Purch-Sales" then
                                 Descr := ItemRec.Description + ItemRec."Description 2" // itos + ItemRec."Description 3"
                             else
                                 Descr := "Purchase Line".Description + ' ' + "Purchase Line"."Description 2";
                         end

                         else*/
                        Descr:="Purchase Line".Description + ' ' + "Purchase Line"."Description 2";
                    end;
                    //NC-102
                    if Type <> Type::Item then begin
                        Descr:="Purchase Line".Description + ' ' + "Purchase Line"."Description 2";
                    end;
                    //NC-102
                    //GSS-ASH
                    CLEAR(AmtInclVAT);
                    if "Amount Including VAT" = 0 then begin
                        AmtInclVAT:="Outstanding Amount";
                    end
                    else
                        AmtInclVAT:="Amount Including VAT";
                    //GSS-ASH
                    TotalAED:=0;
                    RecPurchLine.RESET;
                    RecPurchLine.SETRANGE(RecPurchLine."Document No.", "Purchase Header"."No.");
                    if RecPurchLine.FINDFIRST then begin
                        repeat TotalAED+=RecPurchLine."Amount Including VAT"; //GSS
                            if RecPurchLine."Amount Including VAT" = 0 then TotalAED+=RecPurchLine."Outstanding Amount";
                        until RecPurchLine.NEXT = 0;
                    end;
                    if CurrencyToPrint <> "Purchase Header"."Currency Code" then begin
                        IF(CurrencyToPrint <> GLSetup."LCY Code") AND ("Purchase Header"."GSSCurrency Exchange Rate" = 0)THEN BEGIN
                            //GSS2705
                            "Purchase Line"."Direct Unit Cost":=CurrencyExch.ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, "Purchase Line"."Direct Unit Cost");
                            "Purchase Line"."Line Amount":=CurrencyExch.ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, "Purchase Line"."Line Amount");
                            TotalAED:=CurrencyExch.ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, TotalAED);
                            AmtInclVAT:=CurrencyExch.ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, AmtInclVAT);
                        end
                        else if(CurrencyToPrint <> GLSetup."LCY Code") AND ("Purchase Header"."GSSCurrency Exchange Rate" <> 0)THEN BEGIN
                                //GSS2705
                                //>>GSS2705
                                InsertCurExchTemp(CurrencyToPrint, "Purchase Header"."GSSCurrency Exchange Rate");
                                "Purchase Line"."Direct Unit Cost":=ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, "Purchase Line"."Direct Unit Cost");
                                "Purchase Line"."Line Amount":=ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, "Purchase Line"."Line Amount");
                                TotalAED:=ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, TotalAED);
                                AmtInclVAT:=ExchangeAmtFCYToFCY(TODAY, OrderCurrency, CurrencyToPrint, AmtInclVAT);
                            //<<GSS2705
                            end;
                    end;
                    if amountInwords = '' then begin
                        Check.FormatNoText(Amt, ROUND(TotalAED, 0.01, '='), '');
                        amountInwords:=Amt[2] + Amt[1] + ' ' + CurrencyCode;
                    end;
                end;
            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")ORDER(Ascending);

                column(No; "Purch. Comment Line"."No.")
                {
                }
                column(Comment; "Purch. Comment Line".Comment)
                {
                }
            }
            trigger OnAfterGetRecord();
            begin
                CLEAR(PayTerms); //GSS-ASH
                if PayTerms.GET("Purchase Header"."Payment Terms Code")then; //GSS-ASH
                /* itos
                 PurchasesPayable.GET;
                 SignAuth := PurchasesPayable."Authorised Signatory"; */
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Purchase Header"."Buy-from Vendor No.");
                if Vend.FINDFIRST then begin
                    VendPhone:=Vend."Phone No.";
                    "Vend Fax":=Vend."Fax No.";
                end;
                SalesPersonNam:='';
                if SalesPerson.GET("Purchase Header"."Purchaser Code")then SalesPersonNam:=SalesPerson.Name;
                RecGLSetup.GET;
                if "Purchase Header"."Currency Code" = '' then CurrencyCode:=RecGLSetup."LCY Code"
                else
                    CurrencyCode:="Purchase Header"."Currency Code";
                //NC-101
                //ITOS
                Vend.RESET;
                if Vend.GET("Purchase Header"."Buy-from Vendor No.")then begin
                    Vend.TestField("E-Mail");
                    VendEmail1:=Vend."E-Mail";
                end;
                Vend.RESET;
                if Vend.GET("Purchase Header"."Buy-from Vendor No.")then VendEmail1:=Vend."E-Mail";
                if "Purchase Header"."Buy-from Contact No." <> '' then begin
                    RecContact.GET("Purchase Header"."Buy-from Contact No.");
                    RecContact.TESTFIELD(RecContact."E-Mail");
                    VendEmail1:=RecContact."E-Mail";
                end;
                VendTRN:=Vend."VAT Registration No.";
                //ITOS
                //NC-101
                RecContact.RESET;
                if RecContact.GET("Purchase Header"."Buy-from Contact No.")then;
                if(("Purchase Header".Status = "Purchase Header".Status::Released) or ("Purchase Header".Status = "Purchase Header".Status::"Completely Invoiced")) /* itos or
                ("Purchase Header".Status = "Purchase Header".Status::"4") */then ReportName:='Purchase Order'
                else
                    ReportName:='Purchase Order-Pending For Approval';
                GLSetup.GET;
                OrderCurrency:="Purchase Header"."Currency Code";
                if OrderCurrency = '' then OrderCurrency:=GLSetup."LCY Code";
                if CurrencyToPrint = '' then CurrencyToPrint:="Purchase Header"."GSSCurrency To Print";
                if CurrencyToPrint = '' then CurrencyToPrint:="Purchase Header"."Currency Code";
                if CurrencyToPrint = '' then CurrencyToPrint:=GLSetup."LCY Code";
                CurrencyCode:=CurrencyToPrint;
            /* itos
             "Purchase Header".CALCFIELDS("Purchase Header"."Sales Order");   */
            end;
        }
    }
    requestpage
    {
        layout
        {
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
        CompanyShortcode:=CompInfo."GSSCompany Shortcode";
    end;
    var CompInfo: Record "Company Information";
    Vend: Record Vendor;
    VendPhone: Code[100];
    "Vend Fax": Text;
    VendEmail: Text;
    VendTRN: Text;
    SalesOrder: Text;
    TotalAED: Decimal;
    Check: Report Check;
    Amt: array[2]of Text;
    amountInwords: Text;
    CurrencyCode: Code[20];
    RecGLSetup: Record "General Ledger Setup";
    RecContact: Record Contact;
    ItemRec: Record Item;
    Descr: Text;
    ReportName: Text;
    CurrencyToPrint: Code[10];
    GLSetup: Record "General Ledger Setup";
    CurrencyExch: Record "Currency Exchange Rate" temporary;
    OrderCurrency: Code[10];
    CompanyShortcode: Code[20];
    SalesPerson: Record "Salesperson/Purchaser";
    SalesPersonNam: Text;
    VendEmail1: Text[50];
    RecPurchLine: Record "Purchase Line";
    PurchasesPayable: Record "Purchases & Payables Setup";
    SignAuth: Text;
    PayTerms: Record "Payment Terms";
    AmtInclVAT: Decimal;
    "//": Integer;
    CurrencyExchRate2: array[2]of Record "Currency Exchange Rate" temporary;
    CurrencyExchRate3: array[3]of Record "Currency Exchange Rate" temporary;
    RelExchangeRateAmt: Decimal;
    ExchangeRateAmt: Decimal;
    RelCurrencyCode: Code[10];
    FixExchangeRateAmt: Option;
    CurrencyFactor: Decimal;
    UseAdjmtAmounts: Boolean;
    CurrencyCode2: array[2]of Code[10];
    Date2: array[2]of Date;
    procedure ExchangeAmtLCYToFCY(Date: Date; CurrencyCode: Code[10]; Amount: Decimal; Factor: Decimal): Decimal;
    begin
        if CurrencyCode = '' then exit(Amount);
        FindCurrency(Date, CurrencyCode, 1);
        if CurrencyExch."Relational Currency Code" = '' then if CurrencyExch."Fix Exchange Rate Amount" = CurrencyExch."Fix Exchange Rate Amount"::Both then Amount:=(Amount / CurrencyExch."Relational Exch. Rate Amount") * CurrencyExch."Exchange Rate Amount"
            else
                Amount:=Amount * Factor
        else
        begin
            RelExchangeRateAmt:=CurrencyExch."Relational Exch. Rate Amount";
            ExchangeRateAmt:=CurrencyExch."Exchange Rate Amount";
            RelCurrencyCode:=CurrencyExch."Relational Currency Code";
            FixExchangeRateAmt:=CurrencyExch."Fix Exchange Rate Amount";
            FindCurrency(Date, RelCurrencyCode, 2);
            CurrencyExch.TESTFIELD("Exchange Rate Amount");
            CurrencyExch.TESTFIELD("Relational Exch. Rate Amount");
            case FixExchangeRateAmt of CurrencyExch."Fix Exchange Rate Amount"::"Relational Currency": ExchangeRateAmt:=(Factor * RelExchangeRateAmt * CurrencyExch."Relational Exch. Rate Amount") / CurrencyExch."Exchange Rate Amount";
            CurrencyExch."Fix Exchange Rate Amount"::Currency: RelExchangeRateAmt:=(ExchangeRateAmt * CurrencyExch."Exchange Rate Amount") / (Factor * CurrencyExch."Relational Exch. Rate Amount");
            CurrencyExch."Fix Exchange Rate Amount"::Both: case CurrencyExch."Fix Exchange Rate Amount" of CurrencyExch."Fix Exchange Rate Amount"::"Relational Currency": CurrencyExch."Exchange Rate Amount":=(Factor * RelExchangeRateAmt * CurrencyExch."Relational Exch. Rate Amount") / ExchangeRateAmt;
                CurrencyExch."Fix Exchange Rate Amount"::Currency: CurrencyExch."Relational Exch. Rate Amount":=(ExchangeRateAmt * CurrencyExch."Exchange Rate Amount") / (Factor * RelExchangeRateAmt);
                end;
            end;
            Amount:=(Amount / RelExchangeRateAmt) * ExchangeRateAmt;
            Amount:=(Amount / CurrencyExch."Relational Exch. Rate Amount") * CurrencyExch."Exchange Rate Amount";
        end;
        exit(Amount);
    end;
    procedure ExchangeAmtFCYToLCY(Date: Date; CurrencyCode: Code[10]; Amount: Decimal; Factor: Decimal): Decimal;
    begin
        if CurrencyCode = '' then exit(Amount);
        FindCurrency(Date, CurrencyCode, 1);
        if not UseAdjmtAmounts then begin
            CurrencyExch.TESTFIELD("Exchange Rate Amount");
            CurrencyExch.TESTFIELD("Relational Exch. Rate Amount");
        end
        else
        begin
            CurrencyExch.TESTFIELD("Adjustment Exch. Rate Amount");
            CurrencyExch.TESTFIELD("Relational Adjmt Exch Rate Amt");
            CurrencyExch."Exchange Rate Amount":=CurrencyExch."Adjustment Exch. Rate Amount";
            CurrencyExch."Relational Exch. Rate Amount":=CurrencyExch."Relational Adjmt Exch Rate Amt";
        end;
        if CurrencyExch."Relational Currency Code" = '' then if CurrencyExch."Fix Exchange Rate Amount" = CurrencyExch."Fix Exchange Rate Amount"::Both then Amount:=(Amount / CurrencyExch."Exchange Rate Amount") * CurrencyExch."Relational Exch. Rate Amount"
            else
                Amount:=Amount / Factor
        else
        begin
            RelExchangeRateAmt:=CurrencyExch."Relational Exch. Rate Amount";
            ExchangeRateAmt:=CurrencyExch."Exchange Rate Amount";
            RelCurrencyCode:=CurrencyExch."Relational Currency Code";
            FixExchangeRateAmt:=CurrencyExch."Fix Exchange Rate Amount";
            FindCurrency(Date, RelCurrencyCode, 2);
            if not UseAdjmtAmounts then begin
                CurrencyExch.TESTFIELD("Exchange Rate Amount");
                CurrencyExch.TESTFIELD("Relational Exch. Rate Amount");
            end
            else
            begin
                CurrencyExch.TESTFIELD("Adjustment Exch. Rate Amount");
                CurrencyExch.TESTFIELD("Relational Adjmt Exch Rate Amt");
                CurrencyExch."Exchange Rate Amount":=CurrencyExch."Adjustment Exch. Rate Amount";
                CurrencyExch."Relational Exch. Rate Amount":=CurrencyExch."Relational Adjmt Exch Rate Amt";
            end;
            case FixExchangeRateAmt of CurrencyExch."Fix Exchange Rate Amount"::"Relational Currency": ExchangeRateAmt:=(RelExchangeRateAmt * CurrencyExch."Relational Exch. Rate Amount") / (CurrencyExch."Exchange Rate Amount" * Factor);
            CurrencyExch."Fix Exchange Rate Amount"::Currency: RelExchangeRateAmt:=((Factor * ExchangeRateAmt * CurrencyExch."Exchange Rate Amount") / CurrencyExch."Relational Exch. Rate Amount");
            CurrencyExch."Fix Exchange Rate Amount"::Both: case CurrencyExch."Fix Exchange Rate Amount" of CurrencyExch."Fix Exchange Rate Amount"::"Relational Currency": CurrencyExch."Exchange Rate Amount":=(RelExchangeRateAmt * CurrencyExch."Relational Exch. Rate Amount") / (ExchangeRateAmt * Factor);
                CurrencyExch."Fix Exchange Rate Amount"::Currency: CurrencyExch."Relational Exch. Rate Amount":=((Factor * ExchangeRateAmt * CurrencyExch."Exchange Rate Amount") / RelExchangeRateAmt);
                CurrencyExch."Fix Exchange Rate Amount"::Both: begin
                    Amount:=(Amount / ExchangeRateAmt) * RelExchangeRateAmt;
                    Amount:=(Amount / CurrencyExch."Exchange Rate Amount") * CurrencyExch."Relational Exch. Rate Amount";
                    exit(Amount);
                end;
                end;
            end;
            Amount:=(Amount / RelExchangeRateAmt) * ExchangeRateAmt;
            Amount:=(Amount / CurrencyExch."Relational Exch. Rate Amount") * CurrencyExch."Exchange Rate Amount";
        end;
        exit(Amount);
    end;
    procedure ExchangeAmtFCYToFCY(Date: Date; FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; Amount: Decimal): Decimal;
    begin
        if FromCurrencyCode = ToCurrencyCode then exit(Amount);
        if ToCurrencyCode = '' then begin
            FindCurrency2(Date, FromCurrencyCode, 1);
            if CurrencyExchRate3[1]."Relational Currency Code" = '' then exit((Amount / CurrencyExchRate3[1]."Exchange Rate Amount") * CurrencyExchRate3[1]."Relational Exch. Rate Amount");
            FindCurrency2(Date, CurrencyExchRate3[1]."Relational Currency Code", 3);
            Amount:=((Amount / CurrencyExchRate3[1]."Exchange Rate Amount") * CurrencyExchRate3[1]."Relational Exch. Rate Amount");
            exit((Amount / CurrencyExchRate3[3]."Exchange Rate Amount") * CurrencyExchRate3[3]."Relational Exch. Rate Amount");
        end;
        if FromCurrencyCode = '' then begin
            FindCurrency2(Date, ToCurrencyCode, 2);
            if CurrencyExchRate3[2]."Relational Currency Code" = '' then exit((Amount / CurrencyExchRate3[2]."Relational Exch. Rate Amount") * CurrencyExchRate3[2]."Exchange Rate Amount");
            FindCurrency2(Date, CurrencyExchRate3[2]."Relational Currency Code", 3);
            Amount:=((Amount / CurrencyExchRate3[2]."Relational Exch. Rate Amount") * CurrencyExchRate3[2]."Exchange Rate Amount");
            exit((Amount / CurrencyExchRate3[3]."Relational Exch. Rate Amount") * CurrencyExchRate3[3]."Exchange Rate Amount");
        end;
        FindCurrency2(Date, FromCurrencyCode, 1);
        FindCurrency2(Date, ToCurrencyCode, 2);
        if CurrencyExchRate3[1]."Currency Code" = CurrencyExchRate3[2]."Relational Currency Code" then exit((Amount / CurrencyExchRate3[2]."Relational Exch. Rate Amount") * CurrencyExchRate3[2]."Exchange Rate Amount");
        if CurrencyExchRate3[1]."Relational Currency Code" = CurrencyExchRate3[2]."Currency Code" then exit((Amount / CurrencyExchRate3[1]."Exchange Rate Amount") * CurrencyExchRate3[1]."Relational Exch. Rate Amount");
        if CurrencyExchRate3[1]."Relational Currency Code" = CurrencyExchRate3[2]."Relational Currency Code" then begin
            Amount:=((Amount / CurrencyExchRate3[1]."Exchange Rate Amount") * CurrencyExchRate3[1]."Relational Exch. Rate Amount");
            exit((Amount / CurrencyExchRate3[2]."Relational Exch. Rate Amount") * CurrencyExchRate3[2]."Exchange Rate Amount");
        end;
        if(CurrencyExchRate3[1]."Relational Currency Code" = '') and (CurrencyExchRate3[2]."Relational Currency Code" <> '')then begin
            FindCurrency2(Date, CurrencyExchRate3[2]."Relational Currency Code", 3);
            Amount:=(Amount * CurrencyExchRate3[1]."Relational Exch. Rate Amount") / CurrencyExchRate3[1]."Exchange Rate Amount";
            Amount:=(Amount / CurrencyExchRate3[3]."Relational Exch. Rate Amount") * CurrencyExchRate3[3]."Exchange Rate Amount";
            exit((Amount / CurrencyExchRate3[2]."Relational Exch. Rate Amount") * CurrencyExchRate3[2]."Exchange Rate Amount");
        end;
        if(CurrencyExchRate3[1]."Relational Currency Code" <> '') and (CurrencyExchRate3[2]."Relational Currency Code" = '')then begin
            FindCurrency2(Date, CurrencyExchRate3[1]."Relational Currency Code", 3);
            Amount:=(Amount / CurrencyExchRate3[1]."Exchange Rate Amount") * CurrencyExchRate3[1]."Relational Exch. Rate Amount";
            Amount:=(Amount / CurrencyExchRate3[3]."Exchange Rate Amount") * CurrencyExchRate3[3]."Relational Exch. Rate Amount";
            exit((Amount / CurrencyExchRate3[2]."Relational Exch. Rate Amount") * CurrencyExchRate3[2]."Exchange Rate Amount");
        end;
    end;
    procedure FindCurrency(Date: Date; CurrencyCode: Code[10]; CacheNo: Integer);
    begin
        CurrencyExchRate2[1].DELETEALL;
        CurrencyExchRate2[2].DELETEALL;
        CurrencyExchRate2[3].DELETEALL;
        InsertCurr2(CacheNo);
        if(CurrencyCode2[CacheNo] = CurrencyCode) and (Date2[CacheNo] = Date)then CurrencyExch:=CurrencyExchRate2[CacheNo]
        else
        begin
            if Date = 0D then Date:=WORKDATE;
            CurrencyExchRate2[CacheNo].SETRANGE("Currency Code", CurrencyCode);
            CurrencyExchRate2[CacheNo].SETRANGE("Starting Date", 0D, Date);
            CurrencyExchRate2[CacheNo].FINDLAST;
            CurrencyExch:=CurrencyExchRate2[CacheNo];
            CurrencyCode2[CacheNo]:=CurrencyCode;
            Date2[CacheNo]:=Date;
        end;
    end;
    local procedure FindCurrency2(Date: Date; CurrencyCode: Code[10]; Number: Integer);
    begin
        CurrencyExchRate3[1].DELETEALL;
        CurrencyExchRate3[2].DELETEALL;
        CurrencyExchRate3[3].DELETEALL;
        InsertCurr3(Number);
        if Date = 0D then Date:=WORKDATE;
        CurrencyExchRate3[Number].SETRANGE("Currency Code", CurrencyCode);
        CurrencyExchRate3[Number].SETRANGE("Starting Date", 0D, Date);
        CurrencyExchRate3[Number].FINDLAST;
        CurrencyExchRate3[Number].TESTFIELD("Exchange Rate Amount");
        CurrencyExchRate3[Number].TESTFIELD("Relational Exch. Rate Amount");
    end;
    local procedure InsertCurExchTemp(CurrencyToPrint: Code[10]; PoExchRate: Decimal);
    begin
        CurrencyExch.DELETEALL;
        CurrencyExch.INIT;
        CurrencyExch."Currency Code":='AED';
        CurrencyExch."Starting Date":=TODAY;
        CurrencyExch."Exchange Rate Amount":=1;
        CurrencyExch."Relational Exch. Rate Amount":=1;
        CurrencyExch."Relational Currency Code":='';
        CurrencyExch."Adjustment Exch. Rate Amount":=1;
        CurrencyExch."Relational Adjmt Exch Rate Amt":=1;
        CurrencyExch.INSERT;
        CurrencyExch.INIT;
        CurrencyExch."Currency Code":=CurrencyToPrint;
        CurrencyExch."Starting Date":=TODAY;
        CurrencyExch."Exchange Rate Amount":=1;
        CurrencyExch."Relational Exch. Rate Amount":=PoExchRate;
        CurrencyExch."Relational Currency Code":='';
        CurrencyExch."Adjustment Exch. Rate Amount":=1;
        CurrencyExch."Relational Adjmt Exch Rate Amt":=PoExchRate;
        CurrencyExch.INSERT;
    end;
    local procedure InsertCurr2(Num: Integer);
    begin
        CurrencyExchRate2[Num].DELETEALL;
        if CurrencyExch.FINDFIRST then repeat CurrencyExchRate2[Num].INIT;
                CurrencyExchRate2[Num]."Starting Date":=CurrencyExch."Starting Date";
                CurrencyExchRate2[Num]."Currency Code":=CurrencyExch."Currency Code";
                CurrencyExchRate2[Num]."Exchange Rate Amount":=CurrencyExch."Exchange Rate Amount";
                CurrencyExchRate2[Num]."Relational Exch. Rate Amount":=CurrencyExch."Relational Exch. Rate Amount";
                CurrencyExchRate2[Num]."Adjustment Exch. Rate Amount":=CurrencyExch."Adjustment Exch. Rate Amount";
                CurrencyExchRate2[Num]."Relational Adjmt Exch Rate Amt":=CurrencyExch."Relational Adjmt Exch Rate Amt";
                CurrencyExchRate2[Num].INSERT;
            until CurrencyExch.NEXT = 0;
    end;
    local procedure InsertCurr3(Num: Integer);
    begin
        CurrencyExchRate3[Num].DELETEALL;
        if CurrencyExch.FINDFIRST then repeat CurrencyExchRate3[Num].INIT;
                CurrencyExchRate3[Num]."Starting Date":=CurrencyExch."Starting Date";
                CurrencyExchRate3[Num]."Currency Code":=CurrencyExch."Currency Code";
                CurrencyExchRate3[Num]."Exchange Rate Amount":=CurrencyExch."Exchange Rate Amount";
                CurrencyExchRate3[Num]."Relational Exch. Rate Amount":=CurrencyExch."Relational Exch. Rate Amount";
                CurrencyExchRate3[Num]."Adjustment Exch. Rate Amount":=CurrencyExch."Adjustment Exch. Rate Amount";
                CurrencyExchRate3[Num]."Relational Adjmt Exch Rate Amt":=CurrencyExch."Relational Adjmt Exch Rate Amt";
                CurrencyExchRate3[Num].INSERT;
            until CurrencyExch.NEXT = 0;
    end;
}
