
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьРеквизитыПотерьПриРасхождениях();
	бг_ДобавитьКнопкуРеквизитыПечатиАктаОРасхождениях();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОбработкаВыбораПосле(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.КорректировкаПриобретения.Форма.бг_РеквизитыПечати" Тогда
		
		Если ВыбранноеЗначение <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		КонецЕсли;
		
		Модифицированность = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура бг_КоличествоБойБракПриИзменении(Элемент) 
	
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	КоличествоПотери = ТекущиеДанные.бг_КоличествоБой + ТекущиеДанные.бг_КоличествоБрак;
	КоличествоРасхождение = ?(
		ТекущиеДанные.КоличествоУпаковок < 0, 
		-ТекущиеДанные.КоличествоУпаковок, 
		ТекущиеДанные.КоличествоУпаковок);		
	
	Если КоличествоПотери > КоличествоРасхождение Тогда
		
		ТекущиеДанные[Элемент.Имя] = 0;
		
		ТекстОшибки = НСтр("ru='Общее количество боя или брака не может превышать количества расхождения по документу'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстОшибки,,, 
			"Объект.Расхождения[" + Строка(ТекущиеДанные.НомерСтроки - 1) + "]." + Элемент.Имя); 
		
	КонецЕсли;	
	
	РассчитываемаяСтрока = ?(
		ТекущиеДанные.КоличествоУпаковок < 0, 
		"бг_КоличествоНедостача", 
		"бг_КоличествоИзлишек");
		
	ТекущиеДанные[РассчитываемаяСтрока] = КоличествоРасхождение 
											- ТекущиеДанные.бг_КоличествоБой 
											- ТекущиеДанные.бг_КоличествоБрак;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_ОткрытьРеквизитыПечати(Команда)
	
	ОткрытьФорму(
		"Документ.КорректировкаПриобретения.Форма.бг_РеквизитыПечати", 
		Новый Структура("ДокументОбъект", Объект), 
		ЭтотОбъект);	
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьРеквизитыПотерьПриРасхождениях()
	
	// количество бой
	бг_КоличествоБой = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
							ЭтотОбъект, 
							"бг_КоличествоБой", 
							Элементы.Расхождения, 
							"Объект.Расхождения.бг_КоличествоБой",, 
							Элементы.РасхожденияУпаковкаЕдиницаИзмерения);	

	бг_КоличествоБой.УстановитьДействие("ПриИзменении", "бг_КоличествоБойБракПриИзменении");
	
	// количество брак
	бг_КоличествоБрак = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
							ЭтотОбъект, 
							"бг_КоличествоБрак", 
							Элементы.Расхождения, 
							"Объект.Расхождения.бг_КоличествоБрак",, 
							Элементы.РасхожденияУпаковкаЕдиницаИзмерения);
		
	бг_КоличествоБрак.УстановитьДействие("ПриИзменении", "бг_КоличествоБойБракПриИзменении");
	
	// количество недостача
	бг_КоличествоНедостача = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
								ЭтотОбъект, 
								"бг_КоличествоНедостача", 
								Элементы.Расхождения, 
								"Объект.Расхождения.бг_КоличествоНедостача",, 
								Элементы.РасхожденияУпаковкаЕдиницаИзмерения);
								
	бг_КоличествоНедостача.ТолькоПросмотр = Истина;
	
	// количество излишек
	бг_КоличествоИзлишек = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
								ЭтотОбъект, 
								"бг_КоличествоИзлишек", 
								Элементы.Расхождения, 
								"Объект.Расхождения.бг_КоличествоИзлишек",, 
								Элементы.РасхожденияУпаковкаЕдиницаИзмерения);
								
	бг_КоличествоИзлишек.ТолькоПросмотр = Истина;

КонецПроцедуры	

&НаСервере
Процедура бг_ДобавитьКнопкуРеквизитыПечатиАктаОРасхождениях()  
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект, 
		"бг_РеквизитыПечатиАктаОРасхождениях", 
		Элементы.ГруппаПараметрыЛево, 
		"Реквизиты печати (акт о расхождениях)",
		"бг_ОткрытьРеквизитыПечати", 
		"бг_ОткрытьРеквизитыПечати",, 
		ВидКнопкиФормы.Гиперссылка);	
	
КонецПроцедуры	

#КонецОбласти