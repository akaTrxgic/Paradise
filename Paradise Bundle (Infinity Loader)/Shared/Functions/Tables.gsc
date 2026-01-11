AttachmentNameTable(name)
{
    return "localized;attachment;" + TableLookup("mp/attachmentTable.csv", 4, name, 3);
}