import 'package:congrega/features/tournaments/presentation/event_form_bloc/event_form_bloc.dart';
import 'package:congrega/features/tournaments/presentation/event_form_bloc/event_form_event.dart';
import 'package:congrega/features/tournaments/presentation/event_form_bloc/event_form_state.dart';
import 'package:congrega/features/tournaments/presentation/tournamentPage/tournament_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';

class CreateEventPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateEventPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventFormBloc>(
        create: (context) => KiwiContainer().resolve<EventFormBloc>(),
        child: Scaffold(
          appBar: AppBar(title: Text("Organize a new event")),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: EventFormPageBody(),
            ),
          ),
        ));
  }
}

class EventFormPageBody extends StatelessWidget {
  const EventFormPageBody({Key? key}) : super(key: key);

  static const OutlineInputBorder newEventOutlineInputBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2));

  @override
  Widget build(BuildContext context) {
    return buildFormPage(context);
  }

  Widget buildFormPage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: BlocBuilder<EventFormBloc, EventFormState>(
            buildWhen: (previous, current) => previous.name != current.name,
            builder: (context, state) => Text(
              state.name.value.isEmpty ? "New Event" : state.name.value,
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        BlocBuilder<EventFormBloc, EventFormState>(
          buildWhen: (previous, current) => previous.name != current.name,
          builder: (context, state) => TextFormField(
            onChanged: (name) =>
                context.read<EventFormBloc>().add(EventFormNameChanged(name)),
            decoration: InputDecoration(
              errorText:
                  state.name.invalid ? 'Insert a name for the event' : null,
              labelText: "Name",
              border: newEventOutlineInputBorder,
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        FormatPickerFormField(),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(flex: 70, child: DateTimeFormField()),
            Expanded(flex: 5, child: SizedBox()),
            Expanded(flex: 30, child: TimeFormField()),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          onChanged: (location) => context
              .read<EventFormBloc>()
              .add(EventFormLocationChanged(location)),
          decoration: InputDecoration(
            labelText: "Location",
            border: newEventOutlineInputBorder,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NOTE:",
                style: TextStyle(color: Colors.grey),
              ),
              Text("You will be an admin of this event",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: BlocBuilder<EventFormBloc, EventFormState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) => ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
              ),
              onPressed: state.status == FormzStatus.valid
                  ? () => _sendEvent(context)
                  : null,
              child: Text(
                "CREATE EVENT",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        )
      ],
    );
  }

  _sendEvent(BuildContext context) {
    context.read<EventFormBloc>().add(EventFormSubmitted());
    showDialog(
        context: context,
        builder: (contex) => BlocProvider<EventFormBloc>.value(
              value: context.read<EventFormBloc>(),
              child: CongregaDialog(
                  icon: BlocBuilder<EventFormBloc, EventFormState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      if (state.status == FormzStatus.submissionInProgress)
                        return Container(
                            child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator()));

                      if (state.status == FormzStatus.submissionSuccess)
                        return Icon(Icons.check_circle,
                            color: Colors.green.shade800, size: 50);

                      if (state.status == FormzStatus.submissionFailure)
                        return Icon(Icons.error,
                            color: Colors.red.shade800, size: 50);

                      return Icon(Icons.info, color: Colors.grey, size: 50);
                    },
                  ),
                  title: BlocBuilder<EventFormBloc, EventFormState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        if (state.status == FormzStatus.submissionInProgress)
                          return CongregaDialog.createTitle("Please wait");

                        if (state.status == FormzStatus.submissionSuccess)
                          return CongregaDialog.createTitle("Success!");

                        if (state.status == FormzStatus.submissionFailure)
                          return CongregaDialog.createTitle("Error");

                        return CongregaDialog.createTitle("Something appened");
                      }),
                  body: BlocBuilder<EventFormBloc, EventFormState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      if (state.status == FormzStatus.submissionInProgress)
                        return Text("The event is being created");

                      if (state.status == FormzStatus.submissionSuccess)
                        return Text("Event created correctly");

                      if (state.status == FormzStatus.submissionFailure)
                        return Text(state.errorMsg);

                      return Text(
                          "Something happened during event creation. Try again");
                    },
                  ),
                  buttonRow: BlocBuilder<EventFormBloc, EventFormState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      if (state.status == FormzStatus.submissionSuccess)
                        return TextButton(
                            onPressed: () => Navigator.popUntil(context,
                                ModalRoute.withName(TournamentPage.ROUTE_NAME)),
                            child: Text("OK"));

                      return Text("");
                    },
                  )),
            ));
  }
}

class CongregaDialog extends StatelessWidget {
  const CongregaDialog({
    Key? key,
    this.icon = const Icon(Icons.info),
    this.title = const Text("Title", style: titleTextStyle),
    this.body = const Text("This is the body"),
    this.buttonRow,
  }) : super(key: key);

  static const TextStyle titleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static Widget createTitle(String titleText) =>
      Text(titleText, style: titleTextStyle);

  final Widget icon;
  final Widget title;
  final Widget body;
  final Widget? buttonRow;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(alignment: Alignment.topCenter, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: new BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 25),
          padding: const EdgeInsets.fromLTRB(18, 18 + 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: this.title,
              ),
              this.body,
              SizedBox(
                height: 8,
              ),
              buttonRow ?? SizedBox(height: 4)
            ],
          ),
        ),
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: this.icon,
        )
      ]),
    );
  }
}

class FormatPickerFormField extends StatelessWidget {
  const FormatPickerFormField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormBloc, EventFormState>(
      builder: (context, state) => DropdownButtonFormField<String>(
        decoration: InputDecoration(
          errorText: state.format.invalid ? "Select a format" : null,
          labelText: "Format",
          border: EventFormPageBody.newEventOutlineInputBorder,
        ),
        value: context.read<EventFormBloc>().state.format.value.isEmpty
            ? null
            : context.read<EventFormBloc>().state.format.value,
        items: [
          DropdownMenuItem(child: Text("Standard"), value: "Standard"),
          DropdownMenuItem(child: Text("Modern"), value: "Modern"),
          DropdownMenuItem(child: Text("Commander"), value: "Commander"),
          DropdownMenuItem(child: Text("Legacy"), value: "Legacy"),
          DropdownMenuItem(child: Text("Vintage"), value: "Vintage"),
        ],
        onChanged: (value) {
          if (value != null)
            context.read<EventFormBloc>().add(EventFormatChanged(value));
        },
      ),
    );
  }
}

class DateTimeFormField extends StatefulWidget {
  const DateTimeFormField({
    Key? key,
  }) : super(key: key);

  @override
  State<DateTimeFormField> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends State<DateTimeFormField> {
  late DateTime dateTime;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = context.read<EventFormBloc>().state.startingTime;
    _textEditingController.text = DateFormat("EEEE dd MMMM").format(dateTime);
    return TextField(
      controller: _textEditingController,
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: dateTime,
          firstDate: DateTime(dateTime.year - 50),
          lastDate: DateTime(dateTime.year + 50),
        );
        if (date != null) {
          context.read<EventFormBloc>().add(EventFormDateChanged(date));
          setState(() {
            dateTime = date;
          });
        }
      },
      decoration: InputDecoration(
        labelText: "Date",
        border: EventFormPageBody.newEventOutlineInputBorder,
      ),
    );
  }
}

class TimeFormField extends StatefulWidget {
  @override
  State<TimeFormField> createState() => TimeFormFieldState();
}

class TimeFormFieldState extends State<TimeFormField> {
  late TextEditingController _textEditingController;
  late DateTime dateTime;
  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = context.read<EventFormBloc>().state.startingTime;
    _textEditingController.text = DateFormat("HH:mm").format(dateTime);
    return TextField(
      controller: _textEditingController,
      readOnly: true,
      onTap: () async {
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(dateTime),
        );
        if (time != null) {
          DateTime updatedDateTime = new DateTime(dateTime.year, dateTime.month,
              dateTime.day, time.hour, time.minute);
          context
              .read<EventFormBloc>()
              .add(EventFormDateChanged(updatedDateTime));
          setState(() {
            dateTime = updatedDateTime;
          });
        }
      },
      decoration: InputDecoration(
        labelText: "Time",
        border: EventFormPageBody.newEventOutlineInputBorder,
      ),
    );
  }
}
