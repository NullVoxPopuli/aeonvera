# this join class is similar to a competition response, in that it is used for
# storing data about the registrant's selection of a shirt
class ShirtSelection < AttendanceLineItem
 self.table_name = "attendance_line_items"

 # override the superclass' association with a polymorphic one, cause shirts
 # aren't in teh same table as all the other line items
 belongs_to :line_item, polymorphic: true
end
