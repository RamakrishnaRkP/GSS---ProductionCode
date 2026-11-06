report 60132 "Sales Credit Memo AMP"
{
    Caption = 'Sales Credit Memo AMP';
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/SalesCreditMemo.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';

            column(CurrCode; CurrCode)
            {
            }
            column(CreditMemoNo; "No.")
            {
            }
            column(Bill_to_Customer_No_; "Bill-to Customer No.")
            {
            }
            column(Return_Order_No_; "Return Order No.")
            {
            }
            column(Posting_Date; Format("Posting Date"))
            {
            }
            column(Document_Date; Format("Document Date"))
            {
            }
            column(Prices_Including_VAT; "Prices Including VAT")
            {
            }
            column(CompAddress; CompanyInfo.Address + ' Phone No. : ' + CompanyInfo."Phone No.")
            {
            }
            column(CompTRN; CompanyInfo."VAT Registration No.")
            {
            }
            column(Bill_to_Contact_No_; "Bill-to Contact No.")
            {
            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {
            }
            column(SalesPersonName; SalespersonPurchaser.Name)
            {
            }
            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5;'TRN: ' + CompanyInfo."VAT Registration No." + '            ' + CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyBankName; CompanyBankAccount.Name)
            {
            }
            column(CompanyBankBranchNo; CompanyBankAccount."Bank Branch No.")
            {
            }
            column(CompanyBankAccountNo; CompanyBankAccount."Bank Account No.")
            {
            }
            column(CustomerAddress1; CustAddr[1])
            {
            }
            column(CustomerAddress2; CustAddr[2])
            {
            }
            column(CustomerAddress3; CustAddr[3])
            {
            }
            column(CustomerAddress4; CustAddr[4])
            {
            }
            column(CustomerAddress5; CustAddr[5])
            {
            }
            column(CustomerAddress6; CustAddr[6])
            {
            }
            column(CustomerAddress7; CustAddr[7])
            {
            }
            column(CustomerAddress8; CustAddr[8])
            {
            }
            column(ShipToAddress1; ShipToAddr[1])
            {
            }
            column(ShipToAddress2; ShipToAddr[2])
            {
            }
            column(ShipToAddress3; ShipToAddr[3])
            {
            }
            column(ShipToAddress4; ShipToAddr[4])
            {
            }
            column(ShipToAddress5; ShipToAddr[5])
            {
            }
            column(ShipToAddress6; ShipToAddr[6])
            {
            }
            column(ShipToAddress7; ShipToAddr[7])
            {
            }
            column(ShipToAddress8; ShipToAddr[8])
            {
            }
            dataitem(Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(LineNo_Line; "Line No.")
                {
                }
                column(ItemNo; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(ReceiptDate; Format("Shipment Date"))
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(Unit_Price; "Unit Price")
                {
                }
                column(Line_Discount__; "VAT %")
                {
                }
                column(VAT_Identifier; "Amount Including VAT" - "VAT Base Amount")
                {
                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                }
            }
            trigger OnAfterGetRecord()
            begin
                GLSetup.Get();
                FormatAddressFields(Header);
                if not CompanyBankAccount.Get(Header."Company Bank Account Code")then CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);
                if SalespersonPurchaser.Get("Salesperson Code")then;
                if Header."Currency Code" = '' then CurrCode:=GLSetup."LCY Code"
                else
                    CurrCode:=Header."Currency Code";
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
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        //GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
    end;
    local procedure FormatAddressFields(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatAddr.GetCompanyAddr(SalesCrMemoHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesCrMemoBillTo(CustAddr, SalesCrMemoHeader);
        FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, SalesCrMemoHeader);
    end;
    var CustAddr: array[8]of Text[100];
    ShipToAddr: array[8]of Text[100];
    CompanyAddr: array[8]of Text[100];
    FormatAddr: Codeunit "Format Address";
    SalespersonPurchaser: Record "Salesperson/Purchaser";
    CompanyInfo: Record "Company Information";
    SalesSetup: Record "Sales & Receivables Setup";
    Cust: Record Customer;
    RespCenter: Record "Responsibility Center";
    CompanyBankAccount: Record "Bank Account";
    CurrCode: Code[20];
    GLSetup: Record "General Ledger Setup";
}
