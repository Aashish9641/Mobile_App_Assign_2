import Foundation // Importing the framewor of foundation
import CoreData // importing the core database framework

@objc(Attendance) // attribuet expose to the class
public class Attendance: NSManagedObject, Identifiable {
    // Using NS managed to inform core data managed by framework
    @NSManaged public var id: UUID // using id for attendance
    @NSManaged public var date: Date // storing teh data when the attendace was included or recoreded
    @NSManaged public var status: String // inclduing the status of attendace whether present or absent
    @NSManaged public var student: Student? // studnets are linked with attendance
    @NSManaged public var course: Course? // course is also linked with attendance
    
    // computing teh format of property and data as well
    public var daFor: String {
        let mateFor = DateFormatter() // maiking the instance date formater to remove teh date
        mateFor.dateStyle = .short // fix the style of data as fixed
        mateFor.timeStyle = .short // fix the time stytle as short
        return mateFor.string(from: date) // returning the date as string format
    }
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendance> { // it will request the fetec for attendance entities
        return NSFetchRequest<Attendance>(entityName: "Attendance") // Returing the fetch entity
    }
}
