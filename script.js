const contactForm = document.querySelector('#contact-form');
const formStatus = document.querySelector('#form-status');

if (contactForm && formStatus) {
  contactForm.addEventListener('submit', (event) => {
    event.preventDefault();

    if (!contactForm.reportValidity()) {
      formStatus.textContent = 'Please complete the required fields before previewing your enquiry.';
      return;
    }

    const name = document.querySelector('#name').value.trim();
    formStatus.textContent = `Thanks, ${name}. Your enquiry preview is ready for review and has not been sent anywhere.`;
  });
}
