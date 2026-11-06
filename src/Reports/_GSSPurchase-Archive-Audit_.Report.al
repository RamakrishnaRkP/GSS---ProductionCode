report 60103 "GSSPurchase-Archive-Audit"
{
    RDLCLayout = './src/Reports/Layouts/Purchase-Archive-Audit.rdl';
    DefaultLayout = RDLC;
    ApplicationArea = All;
    Caption = 'Purchase Archive Audit';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header Archive"; "Purchase Header Archive")
        {
            DataItemTableView = sorting("Document Type", "No.", "Doc. No. Occurrence", "Version No.")Order(ascending)where("Document Type"=filter(Order));
            RequestFilterFields = "Document Type", "No.", "Archived By";

            column(CompName; CompInfo.Name)
            {
            }
            column(ShowDetail; ShowDetail)
            {
            }
            column(FilterText; FilterText)
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
            column(Customername; "Purchase Header Archive"."Pay-to Name")
            {
            }
            column(CustomerAddresse; Address)
            {
            }
            column(CustomerContact; Phone)
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(No_; "No.")
            {
            }
            column(Version_No_; "Version No.")
            {
            }
            column(Vendor_Invoice_No_; "Vendor Invoice No.")
            {
            }
            column(Vendor_Name; "Pay-to Name")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Vendor_No_; "Pay-to Vendor No.")
            {
            }
            column(Date_Archived; "Date Archived")
            {
            }
            column(Time_Archived; "Time Archived")
            {
            }
            column(Status; Status)
            {
            }
            column(Archived_By; "Archived By")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(Amount; Amount)
            {
            }
            column(JobNos; JobNos)
            {
            }
            column(ActionText; ActionText)
            {
            }
            trigger OnAfterGetRecord()
            begin
                Clear(ActionText);
                // first record for the document
                if "No." <> PreviousDocNo then begin
                    if Status = Status::Open then ActionText:=Lbl_Created
                    else
                        ActionText:=StrSubstNo('%1', Status);
                    PreviousDocNo:="No.";
                    LastVersionReleased:=false;
                    if Status = Status::Released then LastVersionReleased:=true;
                end
                else
                begin
                    ActionText:=GetAction("Purchase Header Archive", Status);
                    LastVersionReleased:="Purchase Header Archive".Status = "Purchase Header Archive".Status::Released;
                end;
                if not ShowDetail then if CheckIfNextArchiveExists()then CurrReport.Skip();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                field(ShowDetail; ShowDetail)
                {
                    Caption = 'Show Detail';
                    ApplicationArea = All;
                }
            }
        }
    }
    local procedure GetAction(PurchHeader: Record "Purchase Header Archive"; Status: Option): Text[30]begin
        if not LastVersionReleased then begin
            if Status = "Purchase Header Archive".Status::Released then begin
                LastVersionReleased:=true;
                exit(Lbl_Released);
            end;
        //exit(StrSubstNo('%1', "Purchase Header Archive".Status));
        end
        else if("Purchase Header Archive".Status = "Purchase Header Archive".Status::Open)then begin
                exit(Lbl_Reopened);
            end;
        if("Purchase Header Archive"."Receiving No." <> '') and ("Purchase Header Archive"."Posting No." <> '')then begin
            if(CheckIfEverythingInvoiced())then exit(Lbl_EverythingInvoiced);
            exit(Lbl_Received_And_Invoiced)end
        else if("Purchase Header Archive"."Receiving No." <> '')then begin
                if(CheckIfEverythingInvoiced())then exit(Lbl_EverythingInvoiced);
                exit(Lbl_Received)end
            else if("Purchase Header Archive"."Posting No." <> '')then begin
                    if(CheckIfEverythingInvoiced())then exit(Lbl_EverythingInvoiced);
                    exit(Lbl_Invoiced);
                end;
        if CheckIfShortClosed()then exit(Lbl_Short_Close);
        if CheckIfManuallyArchived()then exit(Lbl_ManuallyArchived);
        exit(StrSubstNo('%1', "Purchase Header Archive".Status));
    end;
    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        FilterText:="Purchase Header Archive".GetFilters();
    end;
    local procedure CheckIfEverythingInvoiced(): Boolean;
    var
        PurchLineArchive: Record "Purchase Line Archive";
        EverythingInvoiced: Boolean;
    begin
        // if the document was not archived for receive or invoicing, do not check for quantity
        if("Purchase Header Archive"."Receiving No." = '') and ("Purchase Header Archive"."Posting No." = '')then exit(false);
        EverythingInvoiced:=true;
        PurchLineArchive.SetCurrentKey("Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Line No.");
        PurchLineArchive.SetRange("Document Type", "Purchase Header Archive"."Document Type");
        PurchLineArchive.SetRange("Document No.", "Purchase Header Archive"."No.");
        PurchLineArchive.SetRange("Doc. No. Occurrence", "Purchase Header Archive"."Doc. No. Occurrence");
        PurchLineArchive.SetRange("Version No.", "Purchase Header Archive"."Version No.");
        PurchLineArchive.SetFilter(Quantity, '<>%1', 0);
        if PurchLineArchive.FindFirst()then repeat //check Quantity <> (Qty. To Receive + Quantity Received) and
                // Quantity <> Qty. to Invoice + Quantity Invoiced
                if(PurchLineArchive.Quantity <> (PurchLineArchive."Qty. to Receive" + PurchLineArchive."Quantity Received")) OR (PurchLineArchive.Quantity <> (PurchLineArchive."Qty. to Invoice" + PurchLineArchive."Quantity Invoiced"))then begin
                    EverythingInvoiced:=false;
                end;
            until(PurchLineArchive.Next() = 0) OR EverythingInvoiced;
        exit(EverythingInvoiced);
    end;
    local procedure CheckIfShortClosed(): Boolean var
        PurchHeader: Record "Purchase Header";
        PurchHeaderArchive: Record "Purchase Header Archive";
    begin
        if not CheckIfEverythingInvoiced()then begin
            PurchHeaderArchive.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
            PurchHeaderArchive.SetRange("Document Type", "Purchase Header Archive"."Document Type");
            PurchHeaderArchive.SetRange("No.", "Purchase Header Archive"."No.");
            PurchHeaderArchive.SetFilter("Version No.", '>%1', "Purchase Header Archive"."Version No.");
            if not PurchHeaderArchive.FindFirst()then if not PurchHeader.Get("Purchase Header Archive"."Document Type", "Purchase Header Archive"."No.")then exit(true);
        end;
        exit(false);
    end;
    local procedure CheckIfManuallyArchived(): Boolean var
        myInt: Integer;
    begin
        if CheckIfShortClosed()then exit(false);
        //if last version was not released, and current version is released then the archive will be for release / approval
        if not LastVersionReleased then if "Purchase Header Archive".Status = "Purchase Header Archive".Status::Released then exit(false);
        exit(("Purchase Header Archive"."Receiving No." = '') and ("Purchase Header Archive"."Posting No." = ''));
    end;
    local procedure CheckIfNextArchiveExists(): Boolean var
        PurchHeaderArchive: Record "Purchase Header Archive";
    begin
        PurchHeaderArchive.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
        PurchHeaderArchive.SetRange("Document Type", "Purchase Header Archive"."Document Type");
        PurchHeaderArchive.SetRange("No.", "Purchase Header Archive"."No.");
        PurchHeaderArchive.SetFilter("Version No.", '>%1', "Purchase Header Archive"."Version No.");
        exit(PurchHeaderArchive.FindFirst());
    end;
    var CompInfo: Record "Company Information";
    JobNos: Code[20];
    ActionText: text[30];
    Cust: Record Customer;
    Address: Text[140];
    Phone: Code[50];
    PreviousDocNo: Code[20];
    LastVersionReleased: Boolean;
    Lbl_Created: Label 'Created';
    Lbl_Received: Label 'Received';
    Lbl_Released: Label 'Released';
    Lbl_Reopened: Label 'Re-opened';
    Lbl_Invoiced: Label 'Invoiced';
    Lbl_Received_And_Invoiced: label 'Received & Invoiced';
    Lbl_Short_Close: Label 'Short Closed';
    Lbl_EverythingInvoiced: Label 'Closed';
    Lbl_ManuallyArchived: Label 'Manually Archived';
    FilterText: Text;
    ShowDetail: Boolean;
}
