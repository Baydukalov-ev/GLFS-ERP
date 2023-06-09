#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	бг_ДобавитьКомандуЗаполненияДекларации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_ЗаполнитьДекларацию(Команда)
	бг_ЗаполнитьДекларациюНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИфункции

&НаСервере
Процедура бг_ДобавитьКомандуЗаполненияДекларации()
	ИмяКоманды       = "бг_ЗаполнитьДекларацию";
	ЗаголовокКоманды = НСтр("ru = 'Заполнить'");
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(ЭтотОбъект, ИмяКоманды,
								Элементы.ГруппаКнопокПодготовкаОтчета, ЗаголовокКоманды,
								ИмяКоманды, ИмяКоманды, , ВидКнопкиФормы.КнопкаКоманднойПанели);
КонецПроцедуры

&НаСервере
Процедура бг_ЗаполнитьДекларациюНаСервере()
	ДокументРегламентированныйОтчет = Неопределено;
	
	Если ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок) Тогда
		ДокументРегламентированныйОтчет = СтруктураРеквизитовФормы.мСохраненныйДок.ПолучитьОбъект();
	Иначе
		ТекстСообщения = НСтр("ru = 'Перед заполнением требуется записать декларацию'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Отчеты.РегламентированныйОтчетАкцизыАлкоголь.бг_ЗаполнитьРегламентированныйОтчет(ДокументРегламентированныйОтчет);
	ДокументРегламентированныйОтчет.Записать();
	
	Инициализация();
	
	Расчет(ЭтаФорма, "Раздел2");
	СформироватьРаздел1();
КонецПроцедуры

#КонецОбласти
