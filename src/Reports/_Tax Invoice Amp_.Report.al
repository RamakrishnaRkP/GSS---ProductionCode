report 60130 "Tax Invoice Amp"
{
    Caption = 'Tax Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/TaxInvoiceAMP.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';

            column(No_; "No.")
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Sell_to_Address; "Sell-to Address")
            {
            }
            column(Sell_to_Address_2; "Sell-to Address 2")
            {
            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {
            }
            column(Sell_to_Contact; "Sell-to Contact")
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(External_Document_No_; "External Document No.")
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Document_Date; Format("Document Date"))
            {
            }
            column(CurrencyCode; CurrencyCode)
            {
            }
            column(OverAllAmountInclVAT; OverAllAmountInclVAT)
            {
            }
            column(AmtInWords; Notext[1] + ' ' + NoText[2])
            {
            }
            column(DeliveryDate; Format("Shipment Date"))
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CustomerTRN; CustomerRec."VAT Registration No.")
            {
            }
            column(Delivery_Date; Format(ShipmentDate))
            {
            }
            column(DeliveryNo; ShipmentNo)
            {
            }
            column(CompAddress; CompanyInfo.Address + ' Phone No. : ' + CompanyInfo."Phone No.")
            {
            }
            column(CompTRN; CompanyInfo."VAT Registration No.")
            {
            }
            column(BankName; CompanyBankAccount.Name)
            {
            }
            column(BankAccountNo; CompanyBankAccount."Bank Account No.")
            {
            }
            column(BankIBAN; CompanyBankAccount.IBAN)
            {
            }
            column(BankAddress; CompanyBankAccount.Address)
            {
            }
            column(BankSwift; CompanyBankAccount."SWIFT Code")
            {
            }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(LineNo_Line; "Line No.")
                {
                }
                column(SNo; SNo)
                {
                }
                column(ItemNo; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(Unit_Price; LinePrice)
                {
                }
                column(Amount; Amount)
                {
                }
                column(Allow_Invoice_Disc_; "Allow Invoice Disc.")
                {
                }
                column(VAT_Identifier; "VAT Identifier")
                {
                }
                column(Line_Discount__; "Line Discount %")
                {
                }
                column(Line_Discount_Amount; LineDiscountAmount)
                {
                }
                column(VAT__; "VAT %")
                {
                }
                column(LinePrice; LinePrice)
                {
                }
                column(LineAmount; LineAmount)
                {
                }
                column(TotalAmount; TotalAmount)
                {
                }
                column(VATAmount; VATAmount)
                {
                }
                column(TotalVATAmount; TotalVATAmount)
                {
                }
                column(TotalAmountInclVAT; TotalAmountInclVAT)
                {
                }
                column(Amount_Including_VAT; AmtInclVAT)
                {
                }
                trigger OnAfterGetRecord()
                var
                begin
                    //TotalAmount += Line.Amount;
                    if Quantity <> 0 then SNo+=1;
                    Clear(LineAmount);
                    Clear(VATAmount);
                    Clear(LinePrice);
                    Clear(LineDiscountAmount);
                    Clear(AmtInclVAT);
                    if Quantity = 0 then begin
                        LinePrice:="Unit Price";
                        LineAmount:=0;
                        VATAmount:=0;
                    end
                    else
                    begin
                        LinePrice:=Round(Amount / Quantity, Currency."Unit-Amount Rounding Precision");
                        LineAmount:=Round(Amount * Quantity / Quantity, Currency."Amount Rounding Precision");
                        VATAmount:=Round(Amount * "VAT %" / 100 * Quantity / Quantity, Currency."Amount Rounding Precision");
                        TotalAmount+=LineAmount;
                        TotalVATAmount+=VATAmount;
                        TotalAmountInclVAT+=Round("Amount Including VAT" * Quantity / Quantity, Currency."Amount Rounding Precision");
                    end;
                    if CurrencyFilter = Header."Currency Code" then CurrencyFilter:='';
                    IF CurrencyFilter <> '' THEN begin
                        RecCurrency.RESET;
                        RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                        IF RecCurrency.FIND('+')THEN begin
                            LineAmount:=LineAmount * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            VATAmount:=VATAmount * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            TotalAmount:=TotalAmount * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            TotalVATAmount:=TotalVATAmount * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            TotalAmountInclVAT:=TotalAmountInclVAT * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            LinePrice:=LinePrice * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            AmtInclVAT:="Amount Including VAT" * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                            LineDiscountAmount:="Line Discount Amount" * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount");
                        end;
                    end
                    else
                    begin
                        LineAmount:=LineAmount;
                        VATAmount:=VATAmount;
                        TotalAmount:=TotalAmount;
                        TotalVATAmount:=TotalVATAmount;
                        TotalAmountInclVAT:=TotalAmountInclVAT;
                        LinePrice:=LinePrice;
                        LineDiscountAmount:="Line Discount Amount";
                        AmtInclVAT:="Amount Including VAT";
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
            begin
                Clear(TotalAmount);
                Clear(OverAllAmountInclVAT);
                Clear(SNo);
                //FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
                //FormatAddr.SalesHeaderBillTo(CustAddr, Header);
                // ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, Header);
                if CompanyBankAccount.Get(CompanyInfo."Bank Account No.")then;
                // CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);
                if CustomerRec.Get("Sell-to Customer No.")then;
                if PaymentTermsRec.Get(Header."Payment Terms Code")then;
                if SalesPersonRec.Get(Header."Salesperson Code")then;
                if CurrencyFilter = Header."Currency Code" then CurrencyFilter:='';
                if CurrencyFilter = '' then begin
                    if "Currency Code" = '' then begin
                        GeneralLedgerSetup.Get();
                        GeneralLedgerSetup.TestField("LCY Code");
                        CurrencyCode:=GeneralLedgerSetup."LCY Code";
                        Currency.InitRoundingPrecision;
                    end
                    else
                    begin
                        CurrencyCode:="Currency Code";
                        Currency.Get("Currency Code");
                    end;
                end
                else
                begin
                    CurrencyCode:=CurrencyFilter;
                    Currency.Get(CurrencyFilter);
                end;
                /*  IF Header."Order No." <> '' THEN BEGIN
                     SSHRec.RESET;
                     SSHRec.SETRANGE(SSHRec."Order No.", Header."Order No.");
                     IF SSHRec.FindLast THEN BEGIN
                         ShipmentNo := SSHRec."No.";
                         ShipmentDate := SSHRec."Posting Date";
                     END;
                 END ELSE BEGIN */
                CLEAR(RecSalesInv);
                RecSalesInv.RESET;
                RecSalesInv.SETRANGE("Document No.", Header."No.");
                RecSalesInv.SETRANGE(RecSalesInv.Type, RecSalesInv.Type::Item);
                RecSalesInv.SetFilter(Quantity, '>%1', 0);
                IF RecSalesInv.FINDFIRST THEN BEGIN
                    SSL.Reset();
                    SSL.SetRange("Order No.", RecSalesInv."Order No.");
                    SSL.SetRange("No.", RecSalesInv."No.");
                    SSL.SetRange("Shipment Date", RecSalesInv."Shipment Date");
                    SSL.SetRange(Quantity, RecSalesInv.Quantity);
                    if SSL.FindFirst()then begin
                        ShipmentNo:=SSL."Document No.";
                        ShipmentDate:=SSL."Posting Date";
                    end;
                /*  CLEAR(SSHRec);
                     IF SSHRec.GET(RecSalesInv."Shipment No.") THEN BEGIN
                         ShipmentNo := SSHRec."No.";
                         ShipmentDate := SSHRec."Posting Date";
                     END; */
                END;
                // END;
                //SalesLineRec.SetRange("Document Type", Header."Document Type");
                SalesLineRec.SetRange("Document No.", Header."No.");
                SalesLineRec.SetFilter(Quantity, '<>%1', 0);
                if SalesLineRec.FindSet()then repeat OverAllAmountInclVAT+=Round(SalesLineRec."Amount Including VAT" * SalesLineRec.Quantity / SalesLineRec.Quantity, Currency."Amount Rounding Precision");
                    until SalesLineRec.Next() = 0;
                IF CurrencyFilter <> '' THEN begin
                    RecCurrency.RESET;
                    RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                    IF RecCurrency.FIND('+')THEN OverAllAmountInclVAT:=OverAllAmountInclVAT * (ExchangeRate / RecCurrency."Relational Exch. Rate Amount")end
                else
                    OverAllAmountInclVAT:=OverAllAmountInclVAT;
                ChecRep.InitTextVariable();
                ChecRep.FormatNoText(NoText, Round(OverAllAmountInclVAT), CurrencyCode);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Currency)
                {
                    field("Currency Code"; CurrencyFilter)
                    {
                        ApplicationArea = All;
                        TableRelation = Currency.Code;

                        trigger OnValidate()
                        begin
                            IF CurrencyFilter <> '' THEN begin
                                RecCurrency.RESET;
                                RecCurrency.SETRANGE(RecCurrency."Currency Code", CurrencyFilter);
                                if RecCurrency.FIND('+')then ExchangeRate:=1; //RecCurrency."Relational Exch. Rate Amount";
                            end;
                        end;
                    }
                    field(ExchangeRate; ExchangeRate)
                    {
                        ApplicationArea = All;
                        DecimalPlaces = 0: 3;
                        Editable = false;
                        Visible = false;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        //GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        //SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
    end;
    var CompanyAddr: array[8]of Text[100];
    CompanyInfo: Record "Company Information";
    GeneralLedgerSetup: Record "General Ledger Setup";
    SalesLineRec: Record "Sales Invoice Line";
    Currency: Record Currency;
    CustomerRec: Record Customer;
    SSHRec: Record "Sales Shipment Header";
    RecSalesInv: Record "Sales Invoice Line";
    ChecRep: Report Check;
    FormatAddr: Codeunit "Format Address";
    CompanyBankAccount: Record "Bank Account";
    RespCenter: Record "Responsibility Center";
    PaymentTermsRec: Record "Payment Terms";
    SalesPersonRec: Record "Salesperson/Purchaser";
    CustAddr: array[8]of Text[100];
    ShipToAddr: array[8]of Text[100];
    CompanyInfoBankAccNoLbl: Label 'Account No.';
    CompanyInfoBankNameLbl: Label 'Bank';
    TotalAmount: Decimal;
    LinePrice: Decimal;
    LineAmount: Decimal;
    VATAmount: Decimal;
    TotalVATAmount: Decimal;
    TotalAmountInclVAT: Decimal;
    CurrencyCode: Code[10];
    NoText: array[2]of Text[80];
    OverAllAmountInclVAT: Decimal;
    SNo: Integer;
    ShipmentNo: Code[20];
    ShipmentDate: Date;
    CurrencyFilter: Code[10];
    ExchangeRate: Decimal;
    RecCurrency: Record "Currency Exchange Rate";
    AmtInclVAT: Decimal;
    LineDiscountAmount: Decimal;
    SSL: Record "Sales Shipment Line";
}
