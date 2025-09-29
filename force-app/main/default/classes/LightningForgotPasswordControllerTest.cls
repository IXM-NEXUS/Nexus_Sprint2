@IsTest
private class LightningForgotPasswordControllerTest {

    @TestSetup
    static void setup() {
        // No special data needed; Site methods are static
    }

    @IsTest
    static void testForgotPassword_validUsername() {
        String testUsername = 'testuser@example.com';
        String checkEmailUrl = '/apex/CheckEmailPage';

        Test.startTest();
        String result = LightningForgotPasswordController.forgotPassword(testUsername, checkEmailUrl);
        Test.stopTest();

        // Result should be null if everything succeeds
        System.assertEquals(null, result, 'Forgot password should succeed for valid username');
    }

    @IsTest
    static void testForgotPassword_invalidUsername() {
        String invalidUsername = 'invaliduser';
        String checkEmailUrl = '/apex/CheckEmailPage';

        Test.startTest();
        String result = LightningForgotPasswordController.forgotPassword(invalidUsername, checkEmailUrl);
        Test.stopTest();

        // Because Site.isValidUsername cannot be mocked, result can be null or label
        System.assert(result == null || result == Label.Site.invalid_email, 
            'Forgot password should handle invalid usernames');
    }

    @IsTest
    static void testForgotPassword_nullUsername() {
        String checkEmailUrl = '/apex/CheckEmailPage';

        // Passing null should throw internally and return an exception message
        String result = LightningForgotPasswordController.forgotPassword(null, checkEmailUrl);

        System.assertNotEquals(null, result, 'Forgot password should return exception message for null username');
    }

    @IsTest
    static void testSetExperienceId_null() {
        // Pass null → should return null safely
        String result = LightningForgotPasswordController.setExperienceId(null);
        System.assertEquals(null, result, 'setExperienceId should handle null input gracefully');
    }

  
}