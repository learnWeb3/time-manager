export const validateEmail = (key, value) => {
    const errors = []
    const {
        errors: requiredFieldErrors,
    } = validateRequired(key, value)
    errors.push(...requiredFieldErrors)
    if (value) {
        const regex = new RegExp(/^[a-zA-Z0-1]+@.+\..{2,3}$/)
        if (!regex.test(value)) {
            errors.push(`invalid email format for ${key}`)
        }
    }
    return {
        errors,
        isValid: errors.length === 0
    }
}

export const validatePassword = (key, value) => {
    const errors = []
    const {
        errors: requiredFieldErrors,
    } = validateRequired(key, value)
    errors.push(...requiredFieldErrors)
    return {
        errors,
        isValid: errors.length === 0
    }
}

export const validateRequired = (key, value) => {
    const errors = [];
    if (value === null || value === undefined || value === "") {
        errors.push(`missing required value for ${key}`)
    }
    return {
        errors,
        isValid: errors.length === 0
    }
}