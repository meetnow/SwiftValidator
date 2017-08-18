//
//  ValidationRule.swift
//
//  Created by Jeff Potter on 11/11/14.
//  Copyright (c) 2015 jpotts18. All rights reserved.
//

import Foundation
import UIKit

/**
 `ValidationRule` is a class that creates an object which holds validation info of a field.
 */
public class ValidationRule {
    /// The field
    public var field: ValidatableField
    /// The errorLabel
    public var errorLabel: UILabel?
    /// The rules
    public var rules: [Rule] = []
    
    /**
     Initializes `ValidationRule` instance with field, rules, and errorLabel.
     
     - parameter field: field that holds actual text in field.
     - parameter errorLabel: label that holds error label of field.
     - parameter rules: array of Rule objects, which field will be validated against.
     - returns: An initialized `ValidationRule` object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public init(field: ValidatableField, rules: [Rule], errorLabel: UILabel?){
        self.field = field
        self.errorLabel = errorLabel
        self.rules = rules
    }
    
    /**
     Used to validate the field against its validation rules.
     - returns: `ValidationError` object if at least one error is found. Nil is returned if there are no validation errors.
     */
    public func validateField() -> ValidationError? {
        return self.validateText(self.field.validationText)
    }
    
    /**
     Used to live-validate the field against its validation rules.
     - returns: `ValidationError` object if at least one error is found. Nil is returned if there are no validation errors.
     */
    public func validateField(changingCharactersIn range: NSRange, replacementString string: String) -> ValidationError? {
        let originalText = self.field.validationText as NSString
        return self.validateText(originalText.replacingCharacters(in: range, with: string))
    }
    
    /**
     Used to directly validate text against the field's rules.
     - returns: `ValidationError` object if at least one error is found. Nil is returned if there are no validation errors.
     */
    public func validateText(_ validationText: String) -> ValidationError? {
        return self.rules
            .filter { !$0.validate(validationText) }
            .map { ValidationError(field: self.field, errorLabel: self.errorLabel, error: $0.errorMessage()) }
            .first
    }
}
