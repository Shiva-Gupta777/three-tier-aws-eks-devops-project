const nodemailer = require("nodemailer");


const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT),
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

exports.sendMail = async(receiverEmail,subject,body) => {
    await transporter.sendMail({
    from: process.env.SMTP_FROM,
    to: receiverEmail,
    subject: subject,
    html: body
  });
};
