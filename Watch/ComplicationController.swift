//
//  ComplicationController.swift
//  Sweaty Bird WatchKit Extension
//
//  Created by Patrick DeSantis on 10/12/16.
//  Copyright © 2016 Patrick DeSantis. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        if let template = createTemplate(for: complication) {
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        guard let template = createTemplate(for: complication) else {
            handler(nil)
            return
        }
        handler(template)
    }

    // MARK: - Private
    private func createTemplate(for complication: CLKComplication) -> CLKComplicationTemplate? {
        
        let defaults = UserDefaults.standard
        let Val = defaults.string(forKey: "BlackMarketSavedValue") ?? "--" // logic here is saying if Val="" then set val = "--"

        
        switch complication.family {
        case .circularSmall:

            let template = CLKComplicationTemplateCircularSmallStackText()

            template.line1TextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: Val)
            template.line2TextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: "BsF/$")
            return template
            


        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: Val)
            template.line2TextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: "BsF/$")
            return template

        case .modularSmall:

            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: Val)
            template.line2TextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: "BsF/$")
            return template

        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTallBody()
            template.headerTextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: "Black Market")
            template.bodyTextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: (Val+" BsF/$+"))
            return template
//
//        case .utilitarianSmall:
//            let image = #imageLiteral(resourceName: "Complication/Utilitarian")
//            let imageProvider = CLKImageProvider(onePieceImage: image)
//
//            let template = CLKComplicationTemplateUtilitarianSmallSquare()
//            template.imageProvider = imageProvider
//            return template
//
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: (Val+" BsF+"))
            return template

        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: (Val+" BsF/$"))
            return template
            
                    default: return nil
        }
    }
    
}
